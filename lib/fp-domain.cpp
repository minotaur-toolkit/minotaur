#include "fp-domain.h"

#include "llvm/IR/Constants.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>
#include <map>
#include <optional>
#include <set>
#include <string>
#include <vector>

namespace minotaur {

namespace {

template <typename LeafSet>
struct FPDomainState {
  bool IsFP = false;
  FPOriginKind Origin = FPOriginKind::Unknown;
  LeafSet Leaves;
};

template <typename LeafSet>
FPDomainState<LeafSet> unknownFP() {
  FPDomainState<LeafSet> S;
  S.IsFP = true;
  S.Origin = FPOriginKind::Unknown;
  return S;
}

template <typename LeafSet>
FPDomainState<LeafSet> freshFP() {
  FPDomainState<LeafSet> S;
  S.IsFP = true;
  S.Origin = FPOriginKind::Fresh;
  return S;
}

template <typename LeafSet>
FPDomainState<LeafSet> selectorFP(typename LeafSet::value_type Leaf) {
  FPDomainState<LeafSet> S;
  S.IsFP = true;
  S.Origin = FPOriginKind::Selector;
  S.Leaves.insert(Leaf);
  return S;
}

template <typename LeafSet>
FPDomainState<LeafSet> selectorFrom(const FPDomainState<LeafSet> &S) {
  FPDomainState<LeafSet> Out = S;
  Out.IsFP = true;
  return Out;
}

template <typename LeafSet>
FPDomainState<LeafSet> mergeAlternatives(const FPDomainState<LeafSet> &A,
                                         const FPDomainState<LeafSet> &B) {
  if (!A.IsFP || !B.IsFP)
    return {};

  if (A.Origin == FPOriginKind::Selector &&
      B.Origin == FPOriginKind::Selector) {
    FPDomainState<LeafSet> S;
    S.IsFP = true;
    S.Origin = FPOriginKind::Selector;
    S.Leaves = A.Leaves;
    S.Leaves.insert(B.Leaves.begin(), B.Leaves.end());
    return S;
  }

  if (A.Origin == FPOriginKind::Fresh &&
      B.Origin == FPOriginKind::Fresh)
    return freshFP<LeafSet>();

  return unknownFP<LeafSet>();
}

template <typename LeafSet>
FPValueDomain finalize(const FPDomainState<LeafSet> &S) {
  FPValueDomain D;
  D.IsFP = S.IsFP;
  D.Origin = S.Origin;
  D.DistinctLeaves =
      S.Origin == FPOriginKind::Selector ? S.Leaves.size() : 0;
  return D;
}

enum class TransportOp {
  Leaf,
  Ext,
  Trunc,
  MaxNum,
  MinNum,
  Maximum,
  Minimum,
};

struct FPTransportExpr {
  TransportOp Op = TransportOp::Leaf;
  type Ty;
  std::string LeafName;
  std::vector<FPTransportExpr> Args;

  bool operator==(const FPTransportExpr &Other) const {
    return Op == Other.Op &&
           Ty == Other.Ty &&
           LeafName == Other.LeafName &&
           Args == Other.Args;
  }
};

std::string valueName(const llvm::Value &V) {
  std::string Name;
  llvm::raw_string_ostream OS(Name);
  V.printAsOperand(OS, false);
  return Name;
}

bool isSelectorOp(TransportOp Op) {
  return Op == TransportOp::MaxNum || Op == TransportOp::MinNum ||
         Op == TransportOp::Maximum || Op == TransportOp::Minimum;
}

std::string transportExprKey(const FPTransportExpr &Expr) {
  std::string TyStr;
  llvm::raw_string_ostream TyOS(TyStr);
  TyOS << Expr.Ty;
  TyOS.flush();

  std::string Key;
  Key += std::to_string(static_cast<int>(Expr.Op));
  Key += ":";
  Key += TyStr;
  Key += ":";
  Key += Expr.LeafName;
  Key += "(";
  for (const auto &Arg : Expr.Args) {
    Key += transportExprKey(Arg);
    Key += ",";
  }
  Key += ")";
  return Key;
}

void collectTransportLeaves(const FPTransportExpr &Expr,
                            std::set<std::string> &Leaves) {
  if (Expr.Op == TransportOp::Leaf) {
    Leaves.insert(Expr.LeafName);
    return;
  }
  for (const auto &Arg : Expr.Args)
    collectTransportLeaves(Arg, Leaves);
}

using SourceArgSupport = std::set<std::string>;

std::optional<SourceArgSupport>
mergeSupports(std::optional<SourceArgSupport> A,
              std::optional<SourceArgSupport> B) {
  if (!A || !B)
    return std::nullopt;
  A->insert(B->begin(), B->end());
  return A;
}

std::optional<SourceArgSupport>
computeSourceArgSupport(const llvm::Value &V,
                        std::map<const llvm::Value *,
                                 std::optional<SourceArgSupport>> &Cache);

std::optional<SourceArgSupport>
computeSourceArgSupport(const llvm::Value &V,
                        std::map<const llvm::Value *,
                                 std::optional<SourceArgSupport>> &Cache) {
  auto It = Cache.find(&V);
  if (It != Cache.end())
    return It->second;

  if (llvm::isa<llvm::Constant>(V))
    return Cache[&V] = SourceArgSupport{};

  if (llvm::isa<llvm::Argument>(V))
    return Cache[&V] = SourceArgSupport{valueName(V)};

  auto *I = llvm::dyn_cast<llvm::Instruction>(&V);
  if (!I)
    return Cache[&V] = std::nullopt;

  std::optional<SourceArgSupport> Support = SourceArgSupport{};
  for (const llvm::Value *Op : I->operand_values()) {
    Support = mergeSupports(std::move(Support),
                            computeSourceArgSupport(*Op, Cache));
    if (!Support)
      break;
  }
  Cache[&V] = Support;
  return Support;
}

std::optional<SourceArgSupport> computeSourceArgSupport(const llvm::Value &V) {
  std::map<const llvm::Value *, std::optional<SourceArgSupport>> Cache;
  return computeSourceArgSupport(V, Cache);
}

std::optional<SourceArgSupport> computeCandidateSourceArgSupport(const Inst &I);

std::optional<SourceArgSupport> computeCandidateSourceArgSupport(const Inst &I) {
  if (auto *VarV = dynamic_cast<const Var *>(&I)) {
    if (auto *LLVMV = VarV->getValue())
      return computeSourceArgSupport(*LLVMV);
    return SourceArgSupport{VarV->getName()};
  }

  if (dynamic_cast<const ReservedConst *>(&I))
    return SourceArgSupport{};

  if (dynamic_cast<const Copy *>(&I))
    return SourceArgSupport{};

  if (auto *Op = dynamic_cast<const UnaryOp *>(&I))
    return computeCandidateSourceArgSupport(
        *const_cast<UnaryOp *>(Op)->getOperand());

  if (auto *Op = dynamic_cast<const BinaryOp *>(&I))
    return mergeSupports(
        computeCandidateSourceArgSupport(*const_cast<BinaryOp *>(Op)->getLHS()),
        computeCandidateSourceArgSupport(*const_cast<BinaryOp *>(Op)->getRHS()));

  if (auto *Op = dynamic_cast<const ICmp *>(&I))
    return mergeSupports(
        computeCandidateSourceArgSupport(*const_cast<ICmp *>(Op)->getLHS()),
        computeCandidateSourceArgSupport(*const_cast<ICmp *>(Op)->getRHS()));

  if (auto *Op = dynamic_cast<const FCmp *>(&I))
    return mergeSupports(
        computeCandidateSourceArgSupport(*const_cast<FCmp *>(Op)->getLHS()),
        computeCandidateSourceArgSupport(*const_cast<FCmp *>(Op)->getRHS()));

  if (auto *Op = dynamic_cast<const SIMDBinOpInst *>(&I))
    return mergeSupports(
        computeCandidateSourceArgSupport(
            *const_cast<SIMDBinOpInst *>(Op)->getLHS()),
        computeCandidateSourceArgSupport(
            *const_cast<SIMDBinOpInst *>(Op)->getRHS()));

  if (auto *Op = dynamic_cast<const FakeShuffleInst *>(&I)) {
    auto L = computeCandidateSourceArgSupport(
        *const_cast<FakeShuffleInst *>(Op)->getLHS());
    if (auto *R = const_cast<FakeShuffleInst *>(Op)->getRHS())
      return mergeSupports(std::move(L),
                           computeCandidateSourceArgSupport(*R));
    return L;
  }

  if (auto *Op = dynamic_cast<const ExtractElement *>(&I))
    return computeCandidateSourceArgSupport(
        *const_cast<ExtractElement *>(Op)->getVector());

  if (auto *Op = dynamic_cast<const InsertElement *>(&I))
    return mergeSupports(
        computeCandidateSourceArgSupport(
            *const_cast<InsertElement *>(Op)->getVector()),
        computeCandidateSourceArgSupport(
            *const_cast<InsertElement *>(Op)->getElement()));

  if (auto *Op = dynamic_cast<const VectorReduce *>(&I))
    return computeCandidateSourceArgSupport(
        *const_cast<VectorReduce *>(Op)->getVector());

  if (auto *Op = dynamic_cast<const IntConversion *>(&I))
    return computeCandidateSourceArgSupport(
        *const_cast<IntConversion *>(Op)->getOperand());

  if (auto *Op = dynamic_cast<const FPConversion *>(&I))
    return computeCandidateSourceArgSupport(
        *const_cast<FPConversion *>(Op)->getOperand());

  if (auto *Op = dynamic_cast<const Select *>(&I)) {
    auto Support = mergeSupports(
        computeCandidateSourceArgSupport(*const_cast<Select *>(Op)->getCond()),
        computeCandidateSourceArgSupport(*const_cast<Select *>(Op)->getLHS()));
    return mergeSupports(std::move(Support),
                         computeCandidateSourceArgSupport(
                             *const_cast<Select *>(Op)->getRHS()));
  }

  return std::nullopt;
}

bool supportCovers(const SourceArgSupport &Support,
                   const std::set<std::string> &Required) {
  return std::includes(Support.begin(), Support.end(),
                       Required.begin(), Required.end());
}

bool isLeafExpr(const FPTransportExpr &Expr) {
  return Expr.Op == TransportOp::Leaf;
}

bool isSimpleLeafSelector(const FPTransportExpr &Expr) {
  return isSelectorOp(Expr.Op) && Expr.Args.size() == 2 &&
         isLeafExpr(Expr.Args[0]) && isLeafExpr(Expr.Args[1]);
}

std::optional<FPTransportExpr> foldCastTransport(TransportOp CastOp,
                                                 type ResultTy,
                                                 FPTransportExpr Inner) {
  if (CastOp == TransportOp::Trunc &&
      Inner.Op == TransportOp::Ext &&
      !Inner.Args.empty() &&
      Inner.Args[0].Ty == ResultTy)
    return Inner.Args[0];

  if (CastOp == TransportOp::Trunc &&
      isSelectorOp(Inner.Op) &&
      Inner.Args.size() == 2) {
    std::vector<FPTransportExpr> Folded;
    Folded.reserve(2);
    for (auto &Arg : Inner.Args) {
      if (Arg.Op != TransportOp::Ext || Arg.Args.size() != 1)
        return std::nullopt;
      if (Arg.Args[0].Ty != ResultTy)
        return std::nullopt;
      Folded.push_back(Arg.Args[0]);
    }
    FPTransportExpr Out{Inner.Op, ResultTy, "", std::move(Folded)};
    if (transportExprKey(Out.Args[1]) < transportExprKey(Out.Args[0]))
      std::swap(Out.Args[0], Out.Args[1]);
    if (Out.Args[0] == Out.Args[1])
      return Out.Args[0];
    return Out;
  }

  FPTransportExpr Out{CastOp, ResultTy, "", {std::move(Inner)}};
  return Out;
}

std::optional<FPTransportExpr> normalizeSelector(TransportOp Op,
                                                 type Ty,
                                                 std::optional<FPTransportExpr> L,
                                                 std::optional<FPTransportExpr> R) {
  if (!L || !R)
    return std::nullopt;

  if (*L == *R)
    return *L;

  FPTransportExpr Out{Op, Ty, "", {*L, *R}};
  if (transportExprKey(Out.Args[1]) < transportExprKey(Out.Args[0]))
    std::swap(Out.Args[0], Out.Args[1]);
  return Out;
}

FPDomainState<std::set<std::string>> analyzeExpr(const Inst &I);

FPDomainState<std::set<std::string>> analyzeExprOperand(const Value &V) {
  return analyzeExpr(V);
}

FPDomainState<std::set<std::string>> analyzeExpr(const Inst &I) {
  if (auto *V = dynamic_cast<const Var *>(&I)) {
    if (!V->getType().isFP())
      return {};
    return selectorFP<std::set<std::string>>(V->getName());
  }

  if (auto *RC = dynamic_cast<const ReservedConst *>(&I))
    return RC->getType().isFP() ? unknownFP<std::set<std::string>>()
                                : FPDomainState<std::set<std::string>>{};

  if (auto *CopyInst = dynamic_cast<const minotaur::Copy *>(&I))
    return CopyInst->getType().isFP() ? unknownFP<std::set<std::string>>()
                                      : FPDomainState<std::set<std::string>>{};

  if (auto *Op = dynamic_cast<const FPConversion *>(&I)) {
    if (!Op->getType().isFP())
      return {};

    auto Inner = analyzeExprOperand(*const_cast<FPConversion *>(Op)->getOperand());
    switch (const_cast<FPConversion *>(Op)->getOpcode()) {
    case FPConversion::fptrunc:
    case FPConversion::fpext:
      return Inner.IsFP ? selectorFrom(Inner) : unknownFP<std::set<std::string>>();
    case FPConversion::fptoui:
    case FPConversion::fptosi:
    case FPConversion::uitofp:
    case FPConversion::sitofp:
      return freshFP<std::set<std::string>>();
    }
  }

  if (auto *Op = dynamic_cast<const UnaryOp *>(&I)) {
    if (!Op->getType().isFP())
      return {};
    auto *Operand = const_cast<UnaryOp *>(Op)->getOperand();
    if (const_cast<UnaryOp *>(Op)->getOpcode() == UnaryOp::fneg) {
      if (auto *Inner = dynamic_cast<UnaryOp *>(Operand)) {
        if (Inner->getOpcode() == UnaryOp::fneg)
          return analyzeExprOperand(*Inner->getOperand());
      }
    }
    return freshFP<std::set<std::string>>();
  }

  if (auto *Op = dynamic_cast<const BinaryOp *>(&I)) {
    if (!Op->getType().isFP())
      return {};

    auto L = analyzeExprOperand(*const_cast<BinaryOp *>(Op)->getLHS());
    auto R = analyzeExprOperand(*const_cast<BinaryOp *>(Op)->getRHS());
    switch (const_cast<BinaryOp *>(Op)->getOpcode()) {
    case BinaryOp::fmaxnum:
    case BinaryOp::fminnum:
    case BinaryOp::fmaximum:
    case BinaryOp::fminimum:
      return mergeAlternatives(L, R);
    case BinaryOp::fadd:
    case BinaryOp::fsub:
    case BinaryOp::fmul:
    case BinaryOp::fdiv:
    case BinaryOp::copysign:
      return freshFP<std::set<std::string>>();
    default:
      return Op->getType().isFP() ? freshFP<std::set<std::string>>()
                                  : FPDomainState<std::set<std::string>>{};
    }
  }

  if (auto *Sel = dynamic_cast<const Select *>(&I)) {
    if (!Sel->getType().isFP())
      return {};
    auto L = analyzeExprOperand(*const_cast<Select *>(Sel)->getLHS());
    auto R = analyzeExprOperand(*const_cast<Select *>(Sel)->getRHS());
    return mergeAlternatives(L, R);
  }

  return {};
}

std::optional<FPTransportExpr> normalizeExpr(const Inst &I) {
  if (auto *V = dynamic_cast<const Var *>(&I)) {
    if (!V->getType().isFP())
      return std::nullopt;
    return FPTransportExpr{TransportOp::Leaf, V->getType(), V->getName(), {}};
  }

  if (auto *Op = dynamic_cast<const FPConversion *>(&I)) {
    if (!Op->getType().isFP())
      return std::nullopt;
    auto Inner = normalizeExpr(*const_cast<FPConversion *>(Op)->getOperand());
    if (!Inner)
      return std::nullopt;
    switch (const_cast<FPConversion *>(Op)->getOpcode()) {
    case FPConversion::fpext:
      return foldCastTransport(TransportOp::Ext, Op->getType(), std::move(*Inner));
    case FPConversion::fptrunc:
      return foldCastTransport(TransportOp::Trunc, Op->getType(), std::move(*Inner));
    case FPConversion::fptoui:
    case FPConversion::fptosi:
    case FPConversion::uitofp:
    case FPConversion::sitofp:
      return std::nullopt;
    }
  }

  if (auto *Op = dynamic_cast<const BinaryOp *>(&I)) {
    if (!Op->getType().isFP())
      return std::nullopt;
    auto L = normalizeExpr(*const_cast<BinaryOp *>(Op)->getLHS());
    auto R = normalizeExpr(*const_cast<BinaryOp *>(Op)->getRHS());
    switch (const_cast<BinaryOp *>(Op)->getOpcode()) {
    case BinaryOp::fmaxnum:
      return normalizeSelector(TransportOp::MaxNum, Op->getType(),
                               std::move(L), std::move(R));
    case BinaryOp::fminnum:
      return normalizeSelector(TransportOp::MinNum, Op->getType(),
                               std::move(L), std::move(R));
    case BinaryOp::fmaximum:
      return normalizeSelector(TransportOp::Maximum, Op->getType(),
                               std::move(L), std::move(R));
    case BinaryOp::fminimum:
      return normalizeSelector(TransportOp::Minimum, Op->getType(),
                               std::move(L), std::move(R));
    default:
      return std::nullopt;
    }
  }

  return std::nullopt;
}

FPDomainState<std::set<const llvm::Value *>> analyzeIR(const llvm::Value &V);

FPDomainState<std::set<const llvm::Value *>>
analyzeIROperand(const llvm::Value &V) {
  return analyzeIR(V);
}

FPDomainState<std::set<const llvm::Value *>>
analyzeIR(const llvm::Value &V) {
  auto *Ty = V.getType();
  if (!Ty->getScalarType()->isIEEELikeFPTy())
    return {};

  if (llvm::isa<llvm::Argument>(V))
    return selectorFP<std::set<const llvm::Value *>>(&V);

  if (llvm::isa<llvm::ConstantFP>(V))
    return unknownFP<std::set<const llvm::Value *>>();

  if (auto *I = llvm::dyn_cast<llvm::Instruction>(&V)) {
    if (auto *Freeze = llvm::dyn_cast<llvm::FreezeInst>(I))
      return analyzeIROperand(*Freeze->getOperand(0));

    if (llvm::isa<llvm::FPExtInst>(I) || llvm::isa<llvm::FPTruncInst>(I)) {
      auto Inner = analyzeIROperand(*I->getOperand(0));
      return Inner.IsFP ? selectorFrom(Inner)
                        : unknownFP<std::set<const llvm::Value *>>();
    }

    if (auto *Sel = llvm::dyn_cast<llvm::SelectInst>(I)) {
      auto L = analyzeIROperand(*Sel->getTrueValue());
      auto R = analyzeIROperand(*Sel->getFalseValue());
      return mergeAlternatives(L, R);
    }

    if (auto *Phi = llvm::dyn_cast<llvm::PHINode>(I)) {
      FPDomainState<std::set<const llvm::Value *>> Acc;
      bool HasIncoming = false;
      for (llvm::Value *Incoming : Phi->incoming_values()) {
        auto Next = analyzeIROperand(*Incoming);
        if (!HasIncoming) {
          Acc = Next;
          HasIncoming = true;
          continue;
        }
        Acc = mergeAlternatives(Acc, Next);
      }
      return HasIncoming ? Acc : unknownFP<std::set<const llvm::Value *>>();
    }

    if (auto *Call = llvm::dyn_cast<llvm::CallBase>(I)) {
      if (auto *Callee = Call->getCalledFunction()) {
        switch (Callee->getIntrinsicID()) {
        case llvm::Intrinsic::maxnum:
        case llvm::Intrinsic::minnum:
        case llvm::Intrinsic::maximum:
        case llvm::Intrinsic::minimum: {
          auto L = analyzeIROperand(*Call->getArgOperand(0));
          auto R = analyzeIROperand(*Call->getArgOperand(1));
          return mergeAlternatives(L, R);
        }
        case llvm::Intrinsic::fabs:
        case llvm::Intrinsic::ceil:
        case llvm::Intrinsic::floor:
        case llvm::Intrinsic::round:
        case llvm::Intrinsic::roundeven:
        case llvm::Intrinsic::trunc:
        case llvm::Intrinsic::nearbyint:
        case llvm::Intrinsic::rint:
        case llvm::Intrinsic::copysign:
          return freshFP<std::set<const llvm::Value *>>();
        default:
          return unknownFP<std::set<const llvm::Value *>>();
        }
      }
      return unknownFP<std::set<const llvm::Value *>>();
    }

    if (auto *BO = llvm::dyn_cast<llvm::BinaryOperator>(I)) {
      if (!BO->getType()->getScalarType()->isIEEELikeFPTy())
        return {};
      return freshFP<std::set<const llvm::Value *>>();
    }

    if (auto *Un = llvm::dyn_cast<llvm::UnaryOperator>(I)) {
      if (!Un->getType()->getScalarType()->isIEEELikeFPTy())
        return {};
      if (Un->getOpcode() == llvm::Instruction::FNeg) {
        if (auto *Inner = llvm::dyn_cast<llvm::UnaryOperator>(Un->getOperand(0))) {
          if (Inner->getOpcode() == llvm::Instruction::FNeg)
            return analyzeIROperand(*Inner->getOperand(0));
        }
      }
      return freshFP<std::set<const llvm::Value *>>();
    }

    return unknownFP<std::set<const llvm::Value *>>();
  }

  return unknownFP<std::set<const llvm::Value *>>();
}

std::optional<FPTransportExpr> normalizeIR(const llvm::Value &V) {
  auto *Ty = V.getType();
  if (!Ty->getScalarType()->isIEEELikeFPTy())
    return std::nullopt;

  if (llvm::isa<llvm::Argument>(V))
    return FPTransportExpr{TransportOp::Leaf, type(Ty), valueName(V), {}};

  if (auto *I = llvm::dyn_cast<llvm::Instruction>(&V)) {
    if (auto *Freeze = llvm::dyn_cast<llvm::FreezeInst>(I))
      return normalizeIR(*Freeze->getOperand(0));

    if (llvm::isa<llvm::FPExtInst>(I)) {
      auto Inner = normalizeIR(*I->getOperand(0));
      if (!Inner)
        return std::nullopt;
      return foldCastTransport(TransportOp::Ext, type(Ty), std::move(*Inner));
    }

    if (llvm::isa<llvm::FPTruncInst>(I)) {
      auto Inner = normalizeIR(*I->getOperand(0));
      if (!Inner)
        return std::nullopt;
      return foldCastTransport(TransportOp::Trunc, type(Ty), std::move(*Inner));
    }

    if (auto *Call = llvm::dyn_cast<llvm::CallBase>(I)) {
      if (auto *Callee = Call->getCalledFunction()) {
        auto L = normalizeIR(*Call->getArgOperand(0));
        auto R = normalizeIR(*Call->getArgOperand(1));
        switch (Callee->getIntrinsicID()) {
        case llvm::Intrinsic::maxnum:
          return normalizeSelector(TransportOp::MaxNum, type(Ty),
                                   std::move(L), std::move(R));
        case llvm::Intrinsic::minnum:
          return normalizeSelector(TransportOp::MinNum, type(Ty),
                                   std::move(L), std::move(R));
        case llvm::Intrinsic::maximum:
          return normalizeSelector(TransportOp::Maximum, type(Ty),
                                   std::move(L), std::move(R));
        case llvm::Intrinsic::minimum:
          return normalizeSelector(TransportOp::Minimum, type(Ty),
                                   std::move(L), std::move(R));
        default:
          return std::nullopt;
        }
      }
    }
  }

  return std::nullopt;
}

} // namespace

FPValueDomain analyzeFPValueDomain(const Inst &I) {
  return finalize(analyzeExpr(I));
}

FPValueDomain analyzeFPValueDomain(const llvm::Value &V) {
  return finalize(analyzeIR(V));
}

bool fpDomainsContradict(const FPValueDomain &Src, const FPValueDomain &Cand) {
  if (!Src.IsFP || !Cand.IsFP)
    return false;
  return Src.mustBeSelector() && Cand.mustBeFresh();
}

bool proveFPTransportEquivalent(const llvm::Value &Src, const Inst &Cand) {
  return classifyFPTransportRelation(Src, Cand) ==
         FPTransportRelation::Equivalent;
}

FPTransportRelation classifyFPTransportRelation(const llvm::Value &Src,
                                               const Inst &Cand) {
  auto SrcNorm = normalizeIR(Src);
  auto CandNorm = normalizeExpr(Cand);
  if (SrcNorm) {
    std::set<std::string> RequiredLeaves;
    collectTransportLeaves(*SrcNorm, RequiredLeaves);
    if (RequiredLeaves.size() > 1) {
      auto CandSupport = computeCandidateSourceArgSupport(Cand);
      if (CandSupport && !supportCovers(*CandSupport, RequiredLeaves))
        return FPTransportRelation::Inequivalent;
    }
  }
  if (!SrcNorm || !CandNorm)
    return FPTransportRelation::Unknown;
  if (*SrcNorm == *CandNorm)
    return FPTransportRelation::Equivalent;

  if (isSimpleLeafSelector(*SrcNorm) && isSimpleLeafSelector(*CandNorm) &&
      SrcNorm->Ty == CandNorm->Ty &&
      SrcNorm->Args == CandNorm->Args &&
      SrcNorm->Op != CandNorm->Op)
    return FPTransportRelation::Inequivalent;

  return FPTransportRelation::Unknown;
}

} // namespace minotaur
