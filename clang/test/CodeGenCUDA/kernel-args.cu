// RUN: %clang_cc1 -triple amdgcn-amd-amdhsa -fcuda-is-device \
// RUN:     -emit-llvm %s -o - | FileCheck -check-prefix=AMDGCN %s
// RUN: %clang_cc1 -triple nvptx64-nvidia-cuda- -fcuda-is-device \
// RUN:     -emit-llvm %s -o - | FileCheck -check-prefix=NVPTX %s
#include "Inputs/cuda.h"

struct A {
  int a[32];
};

// AMDGCN: define amdgpu_kernel void @_Z6kernel1A(%struct.A addrspace(4)* byref(%struct.A) align 4 %{{.+}})
// NVPTX: define void @_Z6kernel1A(%struct.A* byval(%struct.A) align 4 %x)
__global__ void kernel(A x) {
}

class Kernel {
public:
  // AMDGCN: define amdgpu_kernel void @_ZN6Kernel12memberKernelE1A(%struct.A addrspace(4)* byref(%struct.A) align 4 %{{.+}})
  // NVPTX: define void @_ZN6Kernel12memberKernelE1A(%struct.A* byval(%struct.A) align 4 %x)
  static __global__ void memberKernel(A x){}
  template<typename T> static __global__ void templateMemberKernel(T x) {}
};


template <typename T>
__global__ void templateKernel(T x) {}

void launch(void*);

void test() {
  Kernel K;
  // AMDGCN: define amdgpu_kernel void @_Z14templateKernelI1AEvT_(%struct.A addrspace(4)* byref(%struct.A) align 4 %{{.+}}
  // NVPTX: define void @_Z14templateKernelI1AEvT_(%struct.A* byval(%struct.A) align 4 %x)
  launch((void*)templateKernel<A>);

  // AMDGCN: define amdgpu_kernel void @_ZN6Kernel20templateMemberKernelI1AEEvT_(%struct.A addrspace(4)* byref(%struct.A) align 4 %{{.+}}
  // NVPTX: define void @_ZN6Kernel20templateMemberKernelI1AEEvT_(%struct.A* byval(%struct.A) align 4 %x)
  launch((void*)Kernel::templateMemberKernel<A>);
}
