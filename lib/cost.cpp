// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "cost.h"
#include "utils.h"

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/MCA/CustomBehaviour.h"
#include "llvm/MCA/InstrBuilder.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCParser/MCAsmParser.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/TargetParser/Host.h"
#include "llvm/TargetParser/SubtargetFeature.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <memory>
#include <mutex>
#include <optional>
#include <string>

using namespace llvm;
using namespace std;

namespace minotaur {

unsigned get_approx_cost(llvm::Function *F);

namespace {

class MCInstCapturingStreamer final : public MCStreamer {
public:
  SmallVector<MCInst, 16> Insts;

  explicit MCInstCapturingStreamer(MCContext &Context) : MCStreamer(Context) {}

  void emitInstruction(const MCInst &Inst,
                       const MCSubtargetInfo & /*STI*/) override {
    Insts.push_back(Inst);
  }

  bool emitSymbolAttribute(MCSymbol * /*Symbol*/,
                           MCSymbolAttr /*Attribute*/) override {
    return true;
  }

  void emitCommonSymbol(MCSymbol * /*Symbol*/, uint64_t /*Size*/,
                        Align /*ByteAlignment*/) override {}

  void emitZerofill(MCSection * /*Section*/, MCSymbol * /*Symbol*/ = nullptr,
                    uint64_t /*Size*/ = 0,
                    Align /*ByteAlignment*/ = Align(1),
                    SMLoc /*Loc*/ = SMLoc()) override {}

  void emitSubsectionsViaSymbols() override {}
  void beginCOFFSymbolDef(const MCSymbol * /*Symbol*/) override {}
  void emitCOFFSymbolStorageClass(int /*StorageClass*/) override {}
  void emitCOFFSymbolType(int /*Type*/) override {}
  void endCOFFSymbolDef() override {}
};

struct HostTargetConfig {
  Triple TheTriple;
  const Target *TheTarget = nullptr;
  string CPU;
  string Features;
};

static void initNativeCostSupport() {
  static once_flag Once;
  std::call_once(Once, [] {
    if (InitializeNativeTarget())
      report_fatal_error("cannot initialize native LLVM target");
    if (InitializeNativeTargetAsmPrinter())
      report_fatal_error("cannot initialize native LLVM asm printer");
    if (InitializeNativeTargetAsmParser())
      report_fatal_error("cannot initialize native LLVM asm parser");
    InitializeAllTargetMCAs();
  });
}

static optional<HostTargetConfig> getHostTargetConfig() {
  initNativeCostSupport();

  HostTargetConfig Config;
  Config.TheTriple = Triple(sys::getDefaultTargetTriple());
  Config.CPU = string(sys::getHostCPUName());

  SubtargetFeatures FeatureBits;
  for (const auto &Feature : sys::getHostCPUFeatures())
    FeatureBits.AddFeature(Feature.getKey(), Feature.getValue());
  Config.Features = FeatureBits.getString();

  string Error;
  Config.TheTarget =
      TargetRegistry::lookupTarget(StringRef(), Config.TheTriple, Error);
  if (!Config.TheTarget) {
    errs() << "error when initializing host target for cost analysis: "
           << Error << "\n";
    return nullopt;
  }

  return Config;
}

static unique_ptr<Module> cloneIntoCostModule(Function *F, Function *&ClonedF) {
  auto M = make_unique<Module>("", F->getContext());
  ClonedF = Function::Create(F->getFunctionType(), F->getLinkage(), "foo", *M);
  ClonedF->copyAttributesFrom(F);
  ClonedF->setCallingConv(F->getCallingConv());

  ValueToValueMapTy VMap;
  for (unsigned i = 0; i < F->arg_size(); ++i)
    VMap[F->getArg(i)] = ClonedF->getArg(i);

  for (auto &BB : *F) {
    for (auto &I : BB) {
      auto *CI = dyn_cast<CallInst>(&I);
      if (!CI)
        continue;
      auto *Callee = CI->getCalledFunction();
      if (!Callee)
        continue;
      M->getOrInsertFunction(Callee->getName(), Callee->getFunctionType(),
                             Callee->getAttributes());
    }
  }

  SmallVector<ReturnInst *, 8> Returns;
  CloneFunctionInto(ClonedF, F, VMap,
                    CloneFunctionChangeType::DifferentModule, Returns);
  eliminate_dead_code(*ClonedF);
  return M;
}

static unique_ptr<TargetMachine>
createHostTargetMachine(const HostTargetConfig &Config) {
  TargetOptions Options;
  return unique_ptr<TargetMachine>(Config.TheTarget->createTargetMachine(
      Config.TheTriple, Config.CPU, Config.Features, Options,
      optional<Reloc::Model>()));
}

static optional<string> emitAssembly(const HostTargetConfig &Config, Module &M) {
  auto TM = createHostTargetMachine(Config);
  if (!TM) {
    errs() << "error when creating host target machine for cost analysis\n";
    return nullopt;
  }

  M.setTargetTriple(Config.TheTriple);
  M.setDataLayout(TM->createDataLayout());

  SmallString<0> AsmBuffer;
  raw_svector_ostream AsmOS(AsmBuffer);
  legacy::PassManager PM;
  if (TM->addPassesToEmitFile(PM, AsmOS, nullptr,
                              CodeGenFileType::AssemblyFile)) {
    errs() << "error when lowering temporary IR for cost analysis\n";
    return nullopt;
  }

  PM.run(M);
  return string(AsmBuffer.str());
}

static optional<SmallVector<MCInst, 16>>
lowerAssemblyToMCInsts(const HostTargetConfig &Config, StringRef Assembly) {
  auto MRI = unique_ptr<MCRegisterInfo>(
      Config.TheTarget->createMCRegInfo(Config.TheTriple.getTriple()));
  auto STI = unique_ptr<MCSubtargetInfo>(
      Config.TheTarget->createMCSubtargetInfo(Config.TheTriple.getTriple(),
                                              Config.CPU, Config.Features));
  auto MCII =
      unique_ptr<MCInstrInfo>(Config.TheTarget->createMCInstrInfo());
  if (!MRI || !STI || !MCII) {
    errs() << "error when creating MC target state for cost analysis\n";
    return nullopt;
  }

  MCTargetOptions MCOptions;
  auto MAI = unique_ptr<MCAsmInfo>(
      Config.TheTarget->createMCAsmInfo(*MRI, Config.TheTriple.getTriple(),
                                        MCOptions));
  if (!MAI) {
    errs() << "error when creating MC asm info for cost analysis\n";
    return nullopt;
  }

  SourceMgr SrcMgr;
  SrcMgr.AddNewSourceBuffer(
      MemoryBuffer::getMemBuffer(Assembly, "minotaur-cost", false), SMLoc());

  MCContext Context(Config.TheTriple, MAI.get(), MRI.get(), STI.get(), &SrcMgr);
  auto MOFI = unique_ptr<MCObjectFileInfo>(
      Config.TheTarget->createMCObjectFileInfo(Context, /*PIC=*/false));
  Context.setObjectFileInfo(MOFI.get());

  MCInstCapturingStreamer Streamer(Context);

  auto IP = unique_ptr<MCInstPrinter>(Config.TheTarget->createMCInstPrinter(
      Config.TheTriple, /*SyntaxVariant=*/0, *MAI, *MCII, *MRI));
  if (!IP) {
    errs() << "error when creating MC instruction printer for cost analysis\n";
    return nullopt;
  }

  raw_ostream &NullOS = nulls();
  formatted_raw_ostream FormattedNullOS(NullOS);
  Config.TheTarget->createAsmTargetStreamer(Streamer, FormattedNullOS,
                                            IP.get());

  auto Parser = unique_ptr<MCAsmParser>(
      createMCAsmParser(SrcMgr, Context, Streamer, *MAI));
  Parser->getLexer().setLexMasmIntegers(true);

  auto TAP = unique_ptr<MCTargetAsmParser>(
      Config.TheTarget->createMCAsmParser(*STI, *Parser, *MCII, MCOptions));
  if (!TAP) {
    errs() << "error when creating MC asm parser for cost analysis\n";
    return nullopt;
  }

  Parser->setTargetParser(*TAP);
  if (Parser->Run(/*NoInitialTextSection=*/false)) {
    errs() << "error when parsing lowered assembly for cost analysis\n";
    return nullopt;
  }

  return Streamer.Insts;
}

static optional<unsigned> getLoweredUOps(const HostTargetConfig &Config,
                                         ArrayRef<MCInst> Insts) {
  auto MRI = unique_ptr<MCRegisterInfo>(
      Config.TheTarget->createMCRegInfo(Config.TheTriple.getTriple()));
  auto STI = unique_ptr<MCSubtargetInfo>(
      Config.TheTarget->createMCSubtargetInfo(Config.TheTriple.getTriple(),
                                              Config.CPU, Config.Features));
  auto MCII =
      unique_ptr<MCInstrInfo>(Config.TheTarget->createMCInstrInfo());
  auto MCIA = unique_ptr<MCInstrAnalysis>(
      Config.TheTarget->createMCInstrAnalysis(MCII.get()));
  if (!MRI || !STI || !MCII) {
    errs() << "error when creating MCA state for cost analysis\n";
    return nullopt;
  }

  if (!STI->getSchedModel().hasInstrSchedModel()) {
    errs() << "error when finding scheduling model for host CPU '"
           << Config.CPU << "'\n";
    return nullopt;
  }

  unique_ptr<mca::InstrumentManager> IM(
      Config.TheTarget->createInstrumentManager(*STI, *MCII));
  if (!IM)
    IM = make_unique<mca::InstrumentManager>(*STI, *MCII);

  unique_ptr<mca::InstrPostProcess> IPP(
      Config.TheTarget->createInstrPostProcess(*STI, *MCII));
  if (!IPP)
    IPP = make_unique<mca::InstrPostProcess>(*STI, *MCII);

  mca::InstrBuilder Builder(*STI, *MCII, *MRI, MCIA.get(), *IM,
                            /*CallLatency=*/100U);
  SmallVector<mca::Instrument *> NoInstruments;
  unsigned TotalUOps = 0;

  IPP->resetState();
  for (const MCInst &Inst : Insts) {
    auto Lowered = Builder.createInstruction(Inst, NoInstruments);
    if (!Lowered) {
      consumeError(Lowered.takeError());
      errs() << "error when lowering MCInst for cost analysis\n";
      return nullopt;
    }

    IPP->postProcessInstruction(*Lowered, Inst);
    TotalUOps += (*Lowered)->getNumMicroOps();
  }

  return TotalUOps;
}

} // namespace

unsigned get_machine_cost(Function *F) {
  auto Config = getHostTargetConfig();
  if (!Config)
    return get_approx_cost(F);

  Function *ClonedF = nullptr;
  auto M = cloneIntoCostModule(F, ClonedF);

  auto Assembly = emitAssembly(*Config, *M);
  if (!Assembly)
    return get_approx_cost(F);

  auto Insts = lowerAssemblyToMCInsts(*Config, *Assembly);
  if (!Insts)
    return get_approx_cost(F);

  auto UOps = getLoweredUOps(*Config, *Insts);
  if (!UOps)
    return get_approx_cost(F);

  return *UOps;
}

unsigned get_approx_cost(llvm::Function *F) {
  unsigned cost = 0;
  for (auto &BB : *F) {
    for (auto &I : BB) {
      if (CallInst *CI = dyn_cast<CallInst>(&I)) {
        auto CalledF = CI->getCalledFunction();
        if (CalledF) {
          if (CalledF->getName().starts_with("__fksv")) {
            cost += 4;
          } else if (CalledF->isIntrinsic()) {
            if (CalledF->getIntrinsicID() == Intrinsic::minnum ||
                CalledF->getIntrinsicID() == Intrinsic::minimum ||
                CalledF->getIntrinsicID() == Intrinsic::maxnum ||
                CalledF->getIntrinsicID() == Intrinsic::maximum) {
              cost += 30;
            } else {
              cost += 2;
            }
          } else {
            cost += 2;
          }
        } else {
          cost += 2;
        }
      } else if (Instruction *BO = dyn_cast<Instruction>(&I)) {
        auto opCode = BO->getOpcode();
        if (opCode == Instruction::UDiv || opCode == Instruction::SDiv ||
            opCode == Instruction::URem || opCode == Instruction::SRem) {
          cost += 10;
        } else if (opCode == Instruction::Mul) {
          cost += 4;
        } else if (opCode == Instruction::FAdd || opCode == Instruction::FSub ||
                   opCode == Instruction::FMul) {
          cost += 30;
        } else if (opCode == Instruction::FDiv || opCode == Instruction::FRem) {
          cost += 80;
        } else if (opCode == Instruction::FNeg) {
          cost += 2;
        } else if (opCode == Instruction::BitCast) {
          cost += 1;
        } else if (opCode == Instruction::Unreachable ||
                   opCode == Instruction::Ret) {
          cost += 0;
        } else if (opCode == Instruction::Select) {
          cost += 4;
        } else if (opCode == Instruction::InsertElement ||
                   opCode == Instruction::ExtractElement ||
                   opCode == Instruction::ShuffleVector) {
          cost += 4;
        } else {
          cost += 2;
        }
      } else {
        cost += 2;
      }
    }
  }
  return cost;
}

} // namespace minotaur
