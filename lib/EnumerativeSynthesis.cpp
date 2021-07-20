// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "ConstantSynthesis.h"
#include "IR.h"
#include "LLVMGen.h"
#include "Slicing.h"

#include "ir/globals.h"
#include "smt/smt.h"
#include "tools/transform.h"
#include "util/symexec.h"
#include "util/config.h"
#include "util/dataflow.h"
#include "util/version.h"
#include "llvm_util/llvm2alive.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Transforms/Utils/Cloning.h"


#include <iostream>
#include <queue>
#include <vector>
#include <set>
#include <map>

using namespace tools;
using namespace util;
using namespace std;
using namespace IR;

namespace vectorsynth {

static void findInputs(llvm::Value *Root,
                       set<unique_ptr<Var>> &Cands,
                       set<unique_ptr<Ptr>> &Pointers,
                       unsigned Max) {
  // breadth-first search
  unordered_set<llvm::Value *> Visited;
  queue<llvm::Value *> Q;
  Q.push(Root);

  while (!Q.empty()) {
    llvm::Value *V = Q.front();
    Q.pop();
    if (Visited.insert(V).second) {
      if (auto I = llvm::dyn_cast<llvm::Instruction>(V)) {
        for (auto &Op : I->operands()) {
          Q.push(Op);
        }
      }

      if (llvm::isa<llvm::Constant>(V))
        continue;
      if (V == Root)
        continue;
      if (V->getType()->isIntOrIntVectorTy())
        Cands.insert(make_unique<Var>(V));
      else if (V->getType()->isPointerTy())
        Pointers.insert(make_unique<Ptr>(V));
      if (Cands.size() >= Max)
        return;
    }
  }
}

static bool getSketches(llvm::Value *V,
                        set<unique_ptr<Var>> &Inputs,
                        set<unique_ptr<Ptr>> &Pointers,
                        vector<pair<unique_ptr<Inst>,
                        set<unique_ptr<ReservedConst>>>> &R) {
  auto &Ctx = V->getContext();
  R.clear();
  vector<VSValue *> Comps;
  for (auto &I : Inputs) {
    Comps.emplace_back(I.get());
  }

  auto RC1 = make_unique<ReservedConst>(nullptr);
  Comps.emplace_back(RC1.get());

  llvm::Type *ty = V->getType();
  // Unary operators
  for (unsigned K = UnaryOp::Op::copy; K <= UnaryOp::Op::copy; ++K) {
    for (auto Op = Comps.begin(); Op != Comps.end(); ++Op) {
      set<unique_ptr<ReservedConst>> RCs;
      Inst *I = nullptr;
      if (dynamic_cast<ReservedConst *>(*Op)) {
        auto T = make_unique<ReservedConst>(ty);
        I = T.get();
        RCs.insert(move(T));
      } else if (dynamic_cast<Var *>(*Op)) {
        // TODO;
        continue;
      }
      UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
      auto UO = make_unique<UnaryOp>(op, *I);
      R.push_back(make_pair(move(UO), move(RCs)));
    }
  }

  for (unsigned K = BinOp::Op::band; K <= BinOp::Op::mul; ++K) {
    BinOp::Op Op = static_cast<BinOp::Op>(K);
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      auto Op1 = BinOp::isCommutative(Op) ? Op0 : Comps.begin();
      for (; Op1 != Comps.end(); ++Op1) {
        Inst *I = nullptr, *J = nullptr;
        set<unique_ptr<ReservedConst>> RCs;

        // (op rc, var)
        if (dynamic_cast<ReservedConst *>(*Op0)) {
          if (auto R = dynamic_cast<Var *>(*Op1)) {
            // ignore icmp temporarily
            if (R->V()->getType() != ty)
              continue;
            auto T = make_unique<ReservedConst>(R->V()->getType());
            I = T.get();
            RCs.insert(move(T));
            J = R;
            if (BinOp::isCommutative(Op)) {
              swap(I, J);
            }
          } else continue;
        }
        // (op var, rc)
        else if (dynamic_cast<ReservedConst *>(*Op1)) {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            // do not generate (- x 3) which can be represented as (+ x -3)
            if (Op == BinOp::Op::sub)
              continue;
            if (L->V()->getType() != ty)
              continue;
            I = L;
            auto T = make_unique<ReservedConst>(L->V()->getType());
            J = T.get();
            RCs.insert(move(T));
          } else continue;
        }
        // (op var, var)
        else {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              if (L->V()->getType() != R->V()->getType())
                continue;
              if (L->V()->getType() != ty)
                continue;
            };
          };
          I = *Op0;
          J = *Op1;
        }
        auto BO = make_unique<BinOp>(Op, *I, *J);
        R.push_back(make_pair(move(BO), move(RCs)));
      }
    }
    
    // BinaryIntrinsics
    for (unsigned K = SIMDBinOp::Op::x86_ssse3_pshuf_b_128;
         K <= SIMDBinOp::Op::x86_avx2_pshuf_b; ++K) {
      // typecheck for return val
      if (!ty->isVectorTy())
        continue;
      llvm::VectorType *vty = llvm::cast<llvm::FixedVectorType>(ty);
      // FIX: Better typecheck
      if (!vty->getElementType()->isIntegerTy())
        continue;

      SIMDBinOp::Op op = static_cast<SIMDBinOp::Op>(K);
      if (SIMDBinOp::binop_ret_v[op].first != vty->getElementCount().getKnownMinValue())
        continue;
      if (SIMDBinOp::binop_ret_v[op].second != vty->getScalarSizeInBits())
        continue;

      for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
        for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
          Inst *I = nullptr, *J = nullptr;
          set<unique_ptr<ReservedConst>> RCs;

          // syntactic prunning
          if (auto L = dynamic_cast<Var *> (*Op0)) {
            // typecheck for op0
            if (!L->V()->getType()->isVectorTy())
              continue;
            llvm::VectorType *aty = llvm::cast<llvm::FixedVectorType>(L->V()->getType());
            // FIX: Better typecheck
            if (aty != vty) continue;
            if (SIMDBinOp::binop_op0_v[op].first  != aty->getElementCount().getKnownMinValue())
              continue;
            if (SIMDBinOp::binop_op0_v[op].second != aty->getScalarSizeInBits()) {
              continue;
            }
          }
          if (auto R = dynamic_cast<Var *>(*Op1)) {
            // typecheck for op1
            if (!R->V()->getType()->isVectorTy())
              continue;
            llvm::VectorType *bty = llvm::cast<llvm::FixedVectorType>(R->V()->getType());
            // FIX: Better typecheck
            if (bty != vty) continue;
            if (SIMDBinOp::binop_op1_v[op].first  != bty->getElementCount().getKnownMinValue())
              continue;
            if (SIMDBinOp::binop_op1_v[op].second != bty->getScalarSizeInBits())
              continue;
          }

          // (op rc, var)
          if (dynamic_cast<ReservedConst *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              unsigned lanes = SIMDBinOp::binop_op0_v[op].first;
              unsigned bits = SIMDBinOp::binop_op0_v[op].second;
              auto aty = llvm::FixedVectorType::get(llvm::IntegerType::get(Ctx, bits), lanes);
              auto T = make_unique<ReservedConst>(aty);
              I = T.get();
              RCs.insert(move(T));
              J = R;
            } else continue;
          }
          // (op var, rc)
          else if (dynamic_cast<ReservedConst *>(*Op1)) {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              unsigned lanes = SIMDBinOp::binop_op1_v[op].first;
              unsigned bits = SIMDBinOp::binop_op1_v[op].second;
              auto bty = llvm::FixedVectorType::get(llvm::IntegerType::get(Ctx, bits), lanes);
              auto T = make_unique<ReservedConst>(bty);
              J = T.get();
              RCs.insert(move(T));
              I = L;
            } else continue;
          }
          // (op var, var)
          else {
            I = *Op0;
            J = *Op1;
          }

          auto BO = make_unique<SIMDBinOpIntr>(op, *I, *J);
          R.push_back(make_pair(move(BO), move(RCs)));
        }
      }
    }
  }

  // ShuffleVector
#if (false)
  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
      if (!V->getType()->isVectorTy())
        continue;
      auto vty = llvm::cast<llvm::VectorType>(V->getType());

      Inst *I = nullptr, *J = nullptr;
      set<unique_ptr<ReservedConst>> RCs;
      // (shufflevecttor rc, var, mask)
      if (dynamic_cast<ReservedConst *>(*Op0)) {
        if (dynamic_cast<Var *>(*Op1))
          continue;
      }
      // (shufflevector var, rc, mask)
      else if (dynamic_cast<ReservedConst *>(*Op1)) {
        if (auto L = dynamic_cast<Var *>(*Op0)) {
          if (!L->V()->getType()->isVectorTy())
            continue;
          auto lvty = llvm::cast<llvm::VectorType>(L->V()->getType());
          if (lvty->getElementType() != vty->getElementType())
            continue;
          I = L;
          auto T = make_unique<ReservedConst>(L->V()->getType());
          J = T.get();
          RCs.insert(move(T));
        } else continue;
      }
      // (shufflevector, var, var, mask)
      else {
        if (auto L = dynamic_cast<Var *>(*Op0)) {
          if (auto R = dynamic_cast<Var *>(*Op1)) {
            if (L->V()->getType() != R->V()->getType())
              continue;
            if (!L->V()->getType()->isVectorTy())
              continue;
            auto lvty = llvm::cast<llvm::VectorType>(L->V()->getType());
            if (lvty->getElementType() != vty->getElementType())
              continue;
          };
        };
        I = *Op0;
        J = *Op1;
      }
      auto mty = llvm::VectorType::get(llvm::Type::getInt32Ty(V->getContext()), vty->getElementCount());
      auto mask = make_unique<ReservedConst>(mty);
      auto BO = make_unique<ShuffleVector>(*I, *J, *mask.get());
      RCs.insert(move(mask));
      R.push_back(make_pair(move(BO), move(RCs)));
    }
  }
#endif

  for (auto &I : Inputs) {
    if (I->V()->getType() != V->getType())
      continue;
    set<unique_ptr<ReservedConst>> RCs;
    auto V = make_unique<Var>(I->V());
    R.push_back(make_pair(move(V), move(RCs)));
  }

  // Load
  for (auto &P : Pointers) {
    auto elemTy = llvm::cast<llvm::PointerType>(P->V()->getType())->getElementType();
    if (elemTy != ty)
      continue;
    set<unique_ptr<ReservedConst>> RCs;
    auto V = make_unique<Load>(*P, elemTy);
    R.push_back(make_pair(move(V), move(RCs)));
  }
  return true;
}

static bool has_nullptr(const Value *v) {
  if (dynamic_cast<const NullPointerValue*>(v) ||
      (dynamic_cast<const UndefValue*>(v) && hasPtr(v->getType())))
      // undef pointer points to the nullblk
    return true;

  if (auto agg = dynamic_cast<const AggregateValue*>(v)) {
    for (auto val : agg->getVals()) {
      if (has_nullptr(val))
        return true;
    }
  }

  return false;
}

static unsigned num_ptrs(const Type &ty) {
  unsigned n = ty.isPtrType();
  if (auto aty = ty.getAsAggregateType())
    n += aty->numPointerElements();
  return n;
}

static bool returns_local(const Value &v) {
  return dynamic_cast<const Alloc*>(&v) ||
         dynamic_cast<const Malloc*>(&v) ||
         dynamic_cast<const Calloc*>(&v);
         // TODO: add noalias fn
}

static bool may_be_nonlocal(Value *ptr) {
  vector<Value*> todo = { ptr };
  set<Value*> seen;
  do {
    ptr = todo.back();
    todo.pop_back();
    if (!seen.insert(ptr).second)
      continue;

    if (returns_local(*ptr))
      continue;

    if (auto gep = dynamic_cast<GEP*>(ptr)) {
      todo.emplace_back(&gep->getPtr());
      continue;
    }

    if (auto c = isNoOp(*ptr)) {
      todo.emplace_back(c);
      continue;
    }

    if (auto phi = dynamic_cast<Phi*>(ptr)) {
      auto ops = phi->operands();
      todo.insert(todo.end(), ops.begin(), ops.end());
      continue;
    }

    if (auto s = dynamic_cast<Select*>(ptr)) {
      todo.emplace_back(s->getTrueValue());
      todo.emplace_back(s->getFalseValue());
      continue;
    }
    return true;

  } while (!todo.empty());

  return false;
}

static pair<Value*, uint64_t> collect_gep_offsets(Value &v) {
  Value *ptr = &v;
  uint64_t offset = 0;

  while (true) {
    if (auto gep = dynamic_cast<GEP*>(ptr)) {
      uint64_t off = gep->getMaxGEPOffset();
      if (off != UINT64_MAX) {
        ptr = &gep->getPtr();
        offset += off;
        continue;
      }
    }
    break;
  }

  return { ptr, offset };
}

static unsigned returns_nonlocal(const Instr &inst,
                                 set<pair<Value*, uint64_t>> &cache) {
  bool rets_nonloc = false;

  if (dynamic_cast<const FnCall*>(&inst) ||
      isCast(ConversionOp::Int2Ptr, inst)) {
    rets_nonloc = true;
  }
  else if (auto load = dynamic_cast<const IR::Load *>(&inst)) {
    if (may_be_nonlocal(&load->getPtr())) {
      rets_nonloc = cache.emplace(collect_gep_offsets(load->getPtr())).second;
    }
  }
  return rets_nonloc ? num_ptrs(inst.getType()) : 0;
}

namespace {
struct CountMemBlock {
  unsigned num_nonlocals = 0;
  set<pair<Value*, uint64_t>> nonlocal_cache;

  void exec(const Instr &i, CountMemBlock &glb_data) {
    if (returns_local(i)) {
      // TODO: can't be path sensitive yet
    } else {
      num_nonlocals += returns_nonlocal(i, nonlocal_cache);
      glb_data.num_nonlocals += returns_nonlocal(i, glb_data.nonlocal_cache);
      num_nonlocals = min(num_nonlocals, glb_data.num_nonlocals);
    }
  }

  void merge(const CountMemBlock &other) {
    // if LHS has x more non-locals than RHS, then it gets to keep the first
    // x cached accessed pointers, as for sure we have accessed all common
    // pointers plus x extra pointers if we go through the LHS path
    unsigned delta = num_nonlocals - other.num_nonlocals;
    bool lhs_larger = num_nonlocals >= other.num_nonlocals;
    if (!lhs_larger) {
      num_nonlocals = other.num_nonlocals;
      delta = -delta;
    }

    for (auto I = nonlocal_cache.begin(); I != nonlocal_cache.end(); ) {
      if (other.nonlocal_cache.count(*I)) {
        ++I;
      } else if (delta > 0) {
        ++I;
        --delta;
      } else {
        I = nonlocal_cache.erase(I);
      }
    }

    for (auto &e : other.nonlocal_cache) {
      if (delta > 0 && nonlocal_cache.emplace(e).second) {
        --delta;
      }
    }
  }
};
}


static void initBitsProgramPointer(Transform &t) {
  // FIXME: varies among address spaces
  bits_program_pointer = t.src.bitsPointers();
  assert(bits_program_pointer > 0 && bits_program_pointer <= 64);
  assert(bits_program_pointer == t.tgt.bitsPointers());
}

static void calculateAndInitConstants(Transform &t) {
  if (!bits_program_pointer)
    initBitsProgramPointer(t);

  const auto &globals_tgt = t.tgt.getGlobalVars();
  const auto &globals_src = t.src.getGlobalVars();
  num_globals_src = globals_src.size();
  unsigned num_globals = num_globals_src;

  heap_block_alignment = 8;

  num_consts_src = 0;
  num_extra_nonconst_tgt = 0;

  for (auto GV : globals_src) {
    if (GV->isConst())
      ++num_consts_src;
  }

  for (auto GVT : globals_tgt) {
    auto I = find_if(globals_src.begin(), globals_src.end(),
      [GVT](auto *GV) -> bool { return GVT->getName() == GV->getName(); });
    if (I == globals_src.end()) {
      ++num_globals;
      if (!GVT->isConst())
        ++num_extra_nonconst_tgt;
    }
  }

  num_ptrinputs = 0;
  for (auto &arg : t.src.getInputs()) {
    auto n = num_ptrs(arg.getType());
    auto in = dynamic_cast<const Input*>(&arg);
    if (in && in->hasAttribute(ParamAttrs::ByVal)) {
      num_globals_src += n;
      num_globals += n;
    } else
      num_ptrinputs += n;
  }

  // The number of local blocks.
  num_locals_src = 0;
  num_locals_tgt = 0;
  uint64_t max_gep_src = 0, max_gep_tgt = 0;
  uint64_t max_alloc_size = 0;
  uint64_t max_access_size = 0;
  uint64_t min_global_size = UINT64_MAX;

  bool nullptr_is_used = false;
  has_int2ptr      = false;
  has_ptr2int      = false;
  has_alloca       = false;
  has_dead_allocas = false;
  has_malloc       = false;
  has_free         = false;
  has_fncall       = false;
  has_null_block   = false;
  does_ptr_store   = false;
  does_ptr_mem_access = false;
  does_int_mem_access = false;
  bool does_any_byte_access = false;

  // Mininum access size (in bytes)
  uint64_t min_access_size = 8;
  unsigned min_vect_elem_sz = 0;
  bool does_mem_access = false;
  bool has_ptr_load = false;
  bool has_vector_bitcast = false;

  for (auto fn : { &t.src, &t.tgt }) {
    unsigned &cur_num_locals = fn == &t.src ? num_locals_src : num_locals_tgt;
    uint64_t &cur_max_gep    = fn == &t.src ? max_gep_src : max_gep_tgt;

    for (auto &v : fn->getInputs()) {
      auto *i = dynamic_cast<const Input *>(&v);
      if (!i)
        continue;

      if (i->hasAttribute(ParamAttrs::Dereferenceable)) {
        does_mem_access = true;
        uint64_t deref_bytes = i->getAttributes().derefBytes;
        max_access_size = max(max_access_size, deref_bytes);
      }
      if (i->hasAttribute(ParamAttrs::DereferenceableOrNull)) {
        // Optimization: unless explicitly compared with a null pointer, don't
        // set nullptr_is_used to true.
        // Null constant pointer will set nullptr_is_used to true anyway.
        // Note that dereferenceable_or_null implies num_ptrinputs > 0,
        // which may turn has_null_block on.
        does_mem_access = true;
        uint64_t deref_bytes = i->getAttributes().derefOrNullBytes;
        max_access_size = max(max_access_size, deref_bytes);
      }
      if (i->hasAttribute(ParamAttrs::ByVal)) {
        does_mem_access = true;
        uint64_t sz = i->getAttributes().blockSize;
        max_access_size = max(max_access_size, sz);
        min_global_size = min_global_size != UINT64_MAX
                            ? gcd(sz, min_global_size)
                            : sz;
      }
    }

    auto update_min_vect_sz = [&](const Type &ty) {
      auto elemsz = minVectorElemSize(ty);
      if (min_vect_elem_sz && elemsz)
        min_vect_elem_sz = gcd(min_vect_elem_sz, elemsz);
      else if (elemsz)
        min_vect_elem_sz = elemsz;
    };

    for (auto BB : fn->getBBs()) {
      for (auto &i : BB->instrs()) {
        if (returns_local(i))
          ++cur_num_locals;

        for (auto op : i.operands()) {
          nullptr_is_used |= has_nullptr(op);
          update_min_vect_sz(op->getType());
        }

        update_min_vect_sz(i.getType());

        if (dynamic_cast<const FnCall*>(&i))
          has_fncall |= true;

        if (auto *mi = dynamic_cast<const MemInstr *>(&i)) {
          max_alloc_size  = max(max_alloc_size, mi->getMaxAllocSize());
          max_access_size = max(max_access_size, mi->getMaxAccessSize());
          cur_max_gep     = add_saturate(cur_max_gep, mi->getMaxGEPOffset());
          has_free       |= mi->canFree();

          auto info = mi->getByteAccessInfo();
          has_ptr_load         |= info.doesPtrLoad;
          does_ptr_store       |= info.doesPtrStore;
          does_int_mem_access  |= info.hasIntByteAccess;
          does_mem_access      |= info.doesMemAccess();
          min_access_size       = gcd(min_access_size, info.byteSize);
          if (info.doesMemAccess() && !info.hasIntByteAccess &&
              !info.doesPtrLoad && !info.doesPtrStore)
            does_any_byte_access = true;

          if (auto alloc = dynamic_cast<const Alloc*>(&i)) {
            has_alloca = true;
            has_dead_allocas |= alloc->initDead();
          } else {
            has_malloc |= dynamic_cast<const Malloc*>(&i) != nullptr ||
                          dynamic_cast<const Calloc*>(&i) != nullptr;
          }

        } else if (isCast(ConversionOp::Int2Ptr, i) ||
                   isCast(ConversionOp::Ptr2Int, i)) {
          max_alloc_size = max_access_size = cur_max_gep = UINT64_MAX;
          has_int2ptr |= isCast(ConversionOp::Int2Ptr, i) != nullptr;
          has_ptr2int |= isCast(ConversionOp::Ptr2Int, i) != nullptr;

        } else if (auto *bc = isCast(ConversionOp::BitCast, i)) {
          auto &t = bc->getType();
          has_vector_bitcast |= t.isVectorType();
          min_access_size = gcd(min_access_size, getCommonAccessSize(t));
        }
      }
    }
  }

  unsigned num_nonlocals_inst_src;
  {
    DenseDataFlow<CountMemBlock> df(t.src);
    num_nonlocals_inst_src = df.getResult().num_nonlocals;
  }

  does_ptr_mem_access = has_ptr_load || does_ptr_store;
  if (does_any_byte_access && !does_int_mem_access && !does_ptr_mem_access)
    // Use int bytes only
    does_int_mem_access = true;

  unsigned num_locals = max(num_locals_src, num_locals_tgt);

  for (auto glbs : { &globals_src, &globals_tgt }) {
    for (auto &glb : *glbs) {
      auto sz = max(glb->size(), (uint64_t)1u);
      max_access_size = max(sz, max_access_size);
      min_global_size = min_global_size != UINT64_MAX
                          ? gcd(sz, min_global_size)
                          : sz;
    }
  }

  // check if null block is needed
  // Global variables cannot be null pointers
  has_null_block = num_ptrinputs > 0 || nullptr_is_used || has_malloc ||
                  has_ptr_load || has_fncall || has_int2ptr;

  num_nonlocals_src = num_globals_src + num_ptrinputs + num_nonlocals_inst_src +
                      has_null_block;

  // Allow at least one non-const global for calls to change
  num_nonlocals_src += has_fncall;

  num_nonlocals = num_nonlocals_src + num_globals - num_globals_src;

  if (!does_int_mem_access && !does_ptr_mem_access && has_fncall)
    does_int_mem_access = true;

  auto has_attr = [&](ParamAttrs::Attribute a) -> bool {
    for (auto fn : { &t.src, &t.tgt }) {
      for (auto &v : fn->getInputs()) {
        auto i = dynamic_cast<const Input*>(&v);
        if (i && i->hasAttribute(a))
          return true;
      }
    }
    return false;
  };
  // The number of bits needed to encode pointer attributes
  // nonnull and byval isn't encoded in ptr attribute bits
  has_nocapture = has_attr(ParamAttrs::NoCapture);
  has_noread = has_attr(ParamAttrs::NoRead);
  has_nowrite = has_attr(ParamAttrs::NoWrite);
  bits_for_ptrattrs = has_nocapture + has_noread + has_nowrite;

  // ceil(log2(maxblks)) + 1 for local bit
  bits_for_bid = max(1u, ilog2_ceil(max(num_locals, num_nonlocals), false))
                   + (num_locals && num_nonlocals);

  // reserve a multiple of 4 for the number of offset bits to make SMT &
  // counterexamples more readable
  // Allow an extra bit for the sign
  auto max_geps
    = ilog2_ceil(add_saturate(max(max_gep_src, max_gep_tgt), max_access_size),
                 true) + 1;
  bits_for_offset = min(round_up(max_geps, 4), (uint64_t)t.src.bitsPtrOffset());
  bits_for_offset = min(bits_for_offset, config::max_offset_bits);

  // we need an extra bit because 1st bit of size is always 0
  bits_size_t = ilog2_ceil(max_alloc_size, true);
  bits_size_t = min(max(bits_for_offset, bits_size_t)+1, bits_program_pointer);

  bits_byte = 8 * (does_mem_access ?  (unsigned)min_access_size : 1);

  bits_poison_per_byte = 1;
  if (min_vect_elem_sz > 0)
    bits_poison_per_byte = (min_vect_elem_sz % 8) ? bits_byte :
                             bits_byte / gcd(bits_byte, min_vect_elem_sz);

  strlen_unroll_cnt = 10;
  memcmp_unroll_cnt = 10;

  little_endian = t.src.isLittleEndian();

  if (config::debug)
    config::dbg() << "\nnum_locals_src: " << num_locals_src
                  << "\nnum_locals_tgt: " << num_locals_tgt
                  << "\nnum_nonlocals_src: " << num_nonlocals_src
                  << "\nnum_nonlocals: " << num_nonlocals
                  << "\nbits_for_bid: " << bits_for_bid
                  << "\nbits_for_offset: " << bits_for_offset
                  << "\nbits_size_t: " << bits_size_t
                  << "\nbits_program_pointer: " << bits_program_pointer
                  << "\nmax_alloc_size: " << max_alloc_size
                  << "\nmin_access_size: " << min_access_size
                  << "\nmax_access_size: " << max_access_size
                  << "\nbits_byte: " << bits_byte
                  << "\nbits_poison_per_byte: " << bits_poison_per_byte
                  << "\nstrlen_unroll_cnt: " << strlen_unroll_cnt
                  << "\nmemcmp_unroll_cnt: " << memcmp_unroll_cnt
                  << "\nlittle_endian: " << little_endian
                  << "\nnullptr_is_used: " << nullptr_is_used
                  << "\nhas_int2ptr: " << has_int2ptr
                  << "\nhas_ptr2int: " << has_ptr2int
                  << "\nhas_malloc: " << has_malloc
                  << "\nhas_free: " << has_free
                  << "\nhas_null_block: " << has_null_block
                  << "\ndoes_ptr_store: " << does_ptr_store
                  << "\ndoes_mem_access: " << does_mem_access
                  << "\ndoes_ptr_mem_access: " << does_ptr_mem_access
                  << "\ndoes_int_mem_access: " << does_int_mem_access
                  << '\n';
}


static optional<smt::smt_initializer> smt_init;
static bool compareFunctions(IR::Function &Func1, IR::Function &Func2,
                             unsigned &goodCount,
                             unsigned &badCount, unsigned &errorCount) {
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
   t.tgt.syncDataWithSrc(t.src);
  calculateAndInitConstants(t);
  TransformVerify verifier(t, false);
  t.print(cout, print_opts);

  {
    auto types = verifier.getTypings();
    if (!types) {
      cerr << "Transformation doesn't verify!\n"
              "ERROR: program doesn't type check!\n\n";
      ++errorCount;
      return true;
    }
    assert(types.hasSingleTyping());
  }

  Errors errs = verifier.verify();
  bool result(errs);
  if (result) {
    if (errs.isUnsound()) {
      cerr << "Transformation doesn't verify!\n" << errs << endl;
      ++badCount;
    } else {
      cerr << errs << endl;
      ++errorCount;
    }
  } else {
    cerr << "Transformation seems to be correct!\n\n";
    ++goodCount;
  }

  return result;
}

static bool
constantSynthesis(IR::Function &Func1, IR::Function &Func2,
                  unsigned &goodCount, unsigned &badCount, unsigned &errorCount,
                  unordered_map<const IR::Value *, llvm::Argument *> &inputMap,
                  unordered_map<llvm::Argument *, llvm::Constant *> &constMap) {
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  calculateAndInitConstants(t);

  vectorsynth::ConstantSynthesis verifier(t);
  t.print(cout, print_opts);
  // assume type verifies
  std::unordered_map<const IR::Value *, smt::expr> result;
  Errors errs = verifier.synthesize(result);

  bool ret(errs);
  if (result.empty())
    return ret;

  for (auto p : inputMap) {
    auto &ty = p.first->getType();
    auto lty = p.second->getType();

    if (ty.isIntType()) {
      // TODO, fix, do not use numeral_string()
      constMap[p.second] = llvm::ConstantInt::get(llvm::cast<llvm::IntegerType>(lty), result[p.first].numeral_string(), 10);
    } else if (ty.isFloatType()) {
      //TODO
      UNREACHABLE();
    } else if (ty.isVectorType()) {
      auto trunk = result[p.first];
      llvm::FixedVectorType *vty = llvm::cast<llvm::FixedVectorType>(lty);
      llvm::IntegerType *ety = llvm::cast<llvm::IntegerType>(vty->getElementType());
      vector<llvm::Constant *> v;
      for (int i = vty->getElementCount().getKnownMinValue() - 1 ; i >= 0 ; i --) {
        unsigned bits = ety->getBitWidth();
        auto elem = trunk.extract((i + 1) * bits - 1, i * bits);
        // TODO: support undef
        if (!elem.isConst())
          return ret;
        v.push_back(llvm::ConstantInt::get(ety, elem.numeral_string(), 10));
      }
      constMap[p.second] = llvm::ConstantVector::get(v);
    }
  }

  goodCount++;

  return ret;
}

static void cleanup(llvm::Function &F) {
  llvm::LoopAnalysisManager LAM;
  llvm::FunctionAnalysisManager FAM;
  llvm::CGSCCAnalysisManager CGAM;
  llvm::ModuleAnalysisManager MAM;

  llvm::PassBuilder PB;
  PB.registerModuleAnalyses(MAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerLoopAnalyses(LAM);
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  llvm::FunctionPassManager FPM;
  FPM.addPass(llvm::DCEPass());
  FPM.run(F, FAM);
}

static void removeUnusedDecls(unordered_set<llvm::Function *> IntrinsicDecls) {
  for (auto Intr : IntrinsicDecls) {
    if (Intr->isDeclaration() && Intr->use_empty()) {
      Intr->eraseFromParent();
    }
  }
}

bool synthesize(llvm::Function &F, llvm::TargetLibraryInfo *TLI) {
  config::disable_undef_input = true;
  config::disable_poison_input = true;
  config::src_unroll_cnt = 2;
  config::tgt_unroll_cnt = 2;

  bool changed = false;

  smt_init.emplace();
  Inst *R = nullptr;
  bool result = false;
  std::unordered_set<llvm::Function *> IntrinsicDecls;

  for (auto &BB : F) {
    for (llvm::BasicBlock::reverse_iterator I = BB.rbegin(), E = BB.rend(); I != E; I++) {
      if (!I->hasNUsesOrMore(1))
        continue;
      unordered_map<llvm::Argument *, llvm::Constant *> constMap;
      set<unique_ptr<Var>> Inputs;
      set<unique_ptr<Ptr>> Pointers;
      findInputs(&*I, Inputs, Pointers, 20);

      vector<pair<unique_ptr<Inst>,set<unique_ptr<ReservedConst>>>> Sketches;
      getSketches(&*I, Inputs, Pointers, Sketches);

      if (Sketches.empty()) continue;

      cout<<"---------Sketches------------"<<endl;
      for (auto &Sketch : Sketches) {
        cout<<*Sketch.first<<endl;
      }
      cout<<"-----------------------------"<<endl;

      struct Comparator {
        bool operator()(tuple<llvm::Function *, llvm::Function *, Inst *, bool>& p1, tuple<llvm::Function *, llvm::Function *, Inst *, bool> &p2) {
          return get<0>(p1)->getInstructionCount() > get<0>(p2)->getInstructionCount();
        }
      };
      unordered_map<string, llvm::Argument *> constants;
      unsigned CI = 0;
      priority_queue<tuple<llvm::Function *, llvm::Function *, Inst *, bool>, vector<tuple<llvm::Function *, llvm::Function *, Inst *, bool>>, Comparator> Fns;

      auto FT = F.getFunctionType();
      // sketches -> llvm functions
      for (auto &Sketch : Sketches) {
        bool HaveC = !Sketch.second.empty();
        auto &G = Sketch.first;
        llvm::ValueToValueMapTy VMap;


        llvm::SmallVector<llvm::Type *, 8> Args;
        for (auto I: FT->params()) {
          Args.push_back(I);
        }
        
        for (auto &C : Sketch.second) {
          Args.push_back(C->T());
        }

        auto nFT = llvm::FunctionType::get(FT->getReturnType(), Args, FT->isVarArg());

        llvm::Function *Tgt = llvm::Function::Create(nFT, F.getLinkage(), F.getName(), F.getParent());

        llvm::SmallVector<llvm::ReturnInst *, 8> TgtReturns;
        llvm::Function::arg_iterator TgtArgI = Tgt->arg_begin();

        for (auto I = F.arg_begin(), E = F.arg_end(); I != E; ++I, ++TgtArgI) {
          VMap[I] = TgtArgI;
          TgtArgI->setName(I->getName());
        }

        // sketches with constants, duplicate F
        for (auto &C : Sketch.second) {
          string arg_name = "_reservedc_" + std::to_string(CI);
          TgtArgI->setName(arg_name);
          constants[arg_name] = TgtArgI;
          C->setA(TgtArgI);
          ++CI;
          ++TgtArgI;
        }

        llvm::CloneFunctionInto(Tgt, &F, VMap, llvm::CloneFunctionChangeType::LocalChangesOnly, TgtReturns);

        llvm::Function *Src;
        if (HaveC) {
          llvm::ValueToValueMapTy _vs;
          Src = llvm::CloneFunction(Tgt, _vs);
        } else {
          Src = &F;
        }

        llvm::Instruction *PrevI = llvm::cast<llvm::Instruction>(VMap[&*I]);
        llvm::Value *V = LLVMGen(PrevI, IntrinsicDecls).codeGen(G.get(), VMap, nullptr);
        PrevI->replaceAllUsesWith(V);

        cleanup(*Tgt);
        if (Tgt->getInstructionCount() >= F.getInstructionCount()) {
          if (HaveC)
            Src->eraseFromParent();
          Tgt->eraseFromParent();
          continue;
        }

        if(!Sketch.second.empty()) {
          cout<<"fun"<<endl;
          F.dump();
          cout<<"src"<<endl;
          Src->dump();
          cout<<"tgt"<<endl;
          Tgt->dump();
        }

        Fns.push(make_tuple(Tgt, Src, G.get(), !Sketch.second.empty()));
      }

      // llvm functions -> alive2 functions, followed by verification or constant synthesis
      while (!Fns.empty()) {
        auto [Tgt, Src, G, HaveC] = Fns.top();
        Fns.pop();
        auto Func1 = llvm_util::llvm2alive(*Src, *TLI);
        auto Func2 = llvm_util::llvm2alive(*Tgt, *TLI);
        unsigned goodCount = 0, badCount = 0, errorCount = 0;
        if (!HaveC) {
          result |= compareFunctions(*Func1, *Func2,
                                     goodCount, badCount, errorCount);
        } else {
          unordered_map<const IR::Value *, llvm::Argument *> inputMap;
          for (auto &I : Func2->getInputs()) {
            string input_name = I.getName();
            // remove "%"
            input_name.erase(0, 1);
            if (constants.count(input_name)) {
              inputMap[&I] = constants[input_name];
            }
          }
          constMap.clear();
          result |= constantSynthesis(*Func1, *Func2,
                                      goodCount, badCount, errorCount,
                                      inputMap, constMap);

          Src->eraseFromParent();
        }
        Tgt->eraseFromParent();
        if (goodCount) {
          R = G;
          break;
        }
      }

      // clean up
      while (!Fns.empty()) {
        auto [Tgt, Src, G, HaveC] = Fns.top();
        Fns.pop();
        (void) G;
        if (HaveC)
          Src->eraseFromParent();
        Tgt->eraseFromParent();
      }

      // replace
      if (R) {
        llvm::ValueToValueMapTy VMap;
        llvm::Value *V = LLVMGen(&*I, IntrinsicDecls).codeGen(R, VMap, &constMap);
        I->replaceAllUsesWith(V);
        cleanup(F);
        changed = true;
        break;
      }
    }
  }
  removeUnusedDecls(IntrinsicDecls);
  return changed;
}

};
