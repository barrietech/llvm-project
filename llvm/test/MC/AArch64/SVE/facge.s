// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

facge   p0.h, p0/z, z0.h, z1.h
// CHECK-INST: facge	p0.h, p0/z, z0.h, z1.h
// CHECK-ENCODING: [0x10,0xc0,0x41,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 c0 41 65 <unknown>

facge   p0.s, p0/z, z0.s, z1.s
// CHECK-INST: facge	p0.s, p0/z, z0.s, z1.s
// CHECK-ENCODING: [0x10,0xc0,0x81,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 c0 81 65 <unknown>

facge   p0.d, p0/z, z0.d, z1.d
// CHECK-INST: facge	p0.d, p0/z, z0.d, z1.d
// CHECK-ENCODING: [0x10,0xc0,0xc1,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 10 c0 c1 65 <unknown>
