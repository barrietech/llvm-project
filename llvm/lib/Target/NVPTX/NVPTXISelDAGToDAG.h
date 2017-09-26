//===-- NVPTXISelDAGToDAG.h - A dag to dag inst selector for NVPTX --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the NVPTX target.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_NVPTX_NVPTXISELDAGTODAG_H
#define LLVM_LIB_TARGET_NVPTX_NVPTXISELDAGTODAG_H

#include "NVPTX.h"
#include "NVPTXISelLowering.h"
#include "NVPTXRegisterInfo.h"
#include "NVPTXTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Compiler.h"

namespace llvm {

class LLVM_LIBRARY_VISIBILITY NVPTXDAGToDAGISel : public SelectionDAGISel {
  const NVPTXTargetMachine &TM;

  // If true, generate mul.wide from sext and mul
  bool doMulWide;

  int getDivF32Level() const;
  bool usePrecSqrtF32() const;
  bool useF32FTZ() const;
  bool allowFMA() const;
  bool allowUnsafeFPMath() const;

public:
  explicit NVPTXDAGToDAGISel(NVPTXTargetMachine &tm,
                             CodeGenOpt::Level   OptLevel);

  // Pass Name
  StringRef getPassName() const override {
    return "NVPTX DAG->DAG Pattern Instruction Selection";
  }
  bool runOnMachineFunction(MachineFunction &MF) override;
  const NVPTXSubtarget *Subtarget;

  bool SelectInlineAsmMemoryOperand(const SDValue &Op,
                                    unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;
private:
// Include the pieces autogenerated from the target description.
#include "NVPTXGenDAGISel.inc"

  void Select(SDNode *N) override;
  bool tryIntrinsicNoChain(SDNode *N);
  bool tryIntrinsicChain(SDNode *N);
  void SelectTexSurfHandle(SDNode *N);
  void SelectMatchAll(SDNode *N);
  bool tryLoad(SDNode *N);
  bool tryLoadVector(SDNode *N);
  bool tryLDGLDU(SDNode *N);
  bool tryStore(SDNode *N);
  bool tryStoreVector(SDNode *N);
  bool tryLoadParam(SDNode *N);
  bool tryStoreRetval(SDNode *N);
  bool tryStoreParam(SDNode *N);
  void SelectAddrSpaceCast(SDNode *N);
  bool tryTextureIntrinsic(SDNode *N);
  bool trySurfaceIntrinsic(SDNode *N);
  bool tryBFE(SDNode *N);
  bool tryConstantFP16(SDNode *N);
  bool SelectSETP_F16X2(SDNode *N);
  bool tryEXTRACT_VECTOR_ELEMENT(SDNode *N);

  inline SDValue getI32Imm(unsigned Imm, const SDLoc &DL) {
    return CurDAG->getTargetConstant(Imm, DL, MVT::i32);
  }

  // Match direct address complex pattern.
  bool SelectDirectAddr(SDValue N, SDValue &Address);

  bool SelectADDRri_imp(SDNode *OpNode, SDValue Addr, SDValue &Base,
                        SDValue &Offset, MVT mvt);
  bool SelectADDRri(SDNode *OpNode, SDValue Addr, SDValue &Base,
                    SDValue &Offset);
  bool SelectADDRri64(SDNode *OpNode, SDValue Addr, SDValue &Base,
                      SDValue &Offset);

  bool SelectADDRsi_imp(SDNode *OpNode, SDValue Addr, SDValue &Base,
                        SDValue &Offset, MVT mvt);
  bool SelectADDRsi(SDNode *OpNode, SDValue Addr, SDValue &Base,
                    SDValue &Offset);
  bool SelectADDRsi64(SDNode *OpNode, SDValue Addr, SDValue &Base,
                      SDValue &Offset);

  bool ChkMemSDNodeAddressSpace(SDNode *N, unsigned int spN) const;

  static unsigned GetConvertOpcode(MVT DestTy, MVT SrcTy, bool IsSigned);
};
} // end namespace llvm

#endif
