// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

// --------------------------------------------------------------------------//
// Test all possible prefetch operation specifiers

prfd    #0, p0, [x0]
// CHECK-INST: prfd	pldl1keep, p0, [x0]
// CHECK-ENCODING: [0x00,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 c0 85 <unknown>

prfd	pldl1keep, p0, [x0]
// CHECK-INST: prfd	pldl1keep, p0, [x0]
// CHECK-ENCODING: [0x00,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 c0 85 <unknown>

prfd    #1, p0, [x0]
// CHECK-INST: prfd	pldl1strm, p0, [x0]
// CHECK-ENCODING: [0x01,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 01 60 c0 85 <unknown>

prfd	pldl1strm, p0, [x0]
// CHECK-INST: prfd	pldl1strm, p0, [x0]
// CHECK-ENCODING: [0x01,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 01 60 c0 85 <unknown>

prfd    #2, p0, [x0]
// CHECK-INST: prfd	pldl2keep, p0, [x0]
// CHECK-ENCODING: [0x02,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 02 60 c0 85 <unknown>

prfd	pldl2keep, p0, [x0]
// CHECK-INST: prfd	pldl2keep, p0, [x0]
// CHECK-ENCODING: [0x02,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 02 60 c0 85 <unknown>

prfd    #3, p0, [x0]
// CHECK-INST: prfd	pldl2strm, p0, [x0]
// CHECK-ENCODING: [0x03,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 03 60 c0 85 <unknown>

prfd	pldl2strm, p0, [x0]
// CHECK-INST: prfd	pldl2strm, p0, [x0]
// CHECK-ENCODING: [0x03,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 03 60 c0 85 <unknown>

prfd    #4, p0, [x0]
// CHECK-INST: prfd	pldl3keep, p0, [x0]
// CHECK-ENCODING: [0x04,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 04 60 c0 85 <unknown>

prfd	pldl3keep, p0, [x0]
// CHECK-INST: prfd	pldl3keep, p0, [x0]
// CHECK-ENCODING: [0x04,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 04 60 c0 85 <unknown>

prfd    #5, p0, [x0]
// CHECK-INST: prfd	pldl3strm, p0, [x0]
// CHECK-ENCODING: [0x05,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 05 60 c0 85 <unknown>

prfd	pldl3strm, p0, [x0]
// CHECK-INST: prfd	pldl3strm, p0, [x0]
// CHECK-ENCODING: [0x05,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 05 60 c0 85 <unknown>

prfd    #6, p0, [x0]
// CHECK-INST: prfd	#6, p0, [x0]
// CHECK-ENCODING: [0x06,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 06 60 c0 85 <unknown>

prfd    #7, p0, [x0]
// CHECK-INST: prfd	#7, p0, [x0]
// CHECK-ENCODING: [0x07,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 07 60 c0 85 <unknown>

prfd    #8, p0, [x0]
// CHECK-INST: prfd	pstl1keep, p0, [x0]
// CHECK-ENCODING: [0x08,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 08 60 c0 85 <unknown>

prfd	pstl1keep, p0, [x0]
// CHECK-INST: prfd	pstl1keep, p0, [x0]
// CHECK-ENCODING: [0x08,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 08 60 c0 85 <unknown>

prfd    #9, p0, [x0]
// CHECK-INST: prfd	pstl1strm, p0, [x0]
// CHECK-ENCODING: [0x09,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 09 60 c0 85 <unknown>

prfd	pstl1strm, p0, [x0]
// CHECK-INST: prfd	pstl1strm, p0, [x0]
// CHECK-ENCODING: [0x09,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 09 60 c0 85 <unknown>

prfd    #10, p0, [x0]
// CHECK-INST: prfd	pstl2keep, p0, [x0]
// CHECK-ENCODING: [0x0a,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0a 60 c0 85 <unknown>

prfd	pstl2keep, p0, [x0]
// CHECK-INST: prfd	pstl2keep, p0, [x0]
// CHECK-ENCODING: [0x0a,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0a 60 c0 85 <unknown>

prfd    #11, p0, [x0]
// CHECK-INST: prfd	pstl2strm, p0, [x0]
// CHECK-ENCODING: [0x0b,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0b 60 c0 85 <unknown>

prfd	pstl2strm, p0, [x0]
// CHECK-INST: prfd	pstl2strm, p0, [x0]
// CHECK-ENCODING: [0x0b,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0b 60 c0 85 <unknown>

prfd    #12, p0, [x0]
// CHECK-INST: prfd	pstl3keep, p0, [x0]
// CHECK-ENCODING: [0x0c,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0c 60 c0 85 <unknown>

prfd	pstl3keep, p0, [x0]
// CHECK-INST: prfd	pstl3keep, p0, [x0]
// CHECK-ENCODING: [0x0c,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0c 60 c0 85 <unknown>

prfd    #13, p0, [x0]
// CHECK-INST: prfd	pstl3strm, p0, [x0]
// CHECK-ENCODING: [0x0d,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0d 60 c0 85 <unknown>

prfd	pstl3strm, p0, [x0]
// CHECK-INST: prfd	pstl3strm, p0, [x0]
// CHECK-ENCODING: [0x0d,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0d 60 c0 85 <unknown>

prfd    #14, p0, [x0]
// CHECK-INST: prfd	#14, p0, [x0]
// CHECK-ENCODING: [0x0e,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0e 60 c0 85 <unknown>

prfd    #15, p0, [x0]
// CHECK-INST: prfd	#15, p0, [x0]
// CHECK-ENCODING: [0x0f,0x60,0xc0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 0f 60 c0 85 <unknown>

// --------------------------------------------------------------------------//
// Test addressing modes

prfd    pldl1strm, p0, [x0, #-32, mul vl]
// CHECK-INST: prfd     pldl1strm, p0, [x0, #-32, mul vl]
// CHECK-ENCODING: [0x01,0x60,0xe0,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 01 60 e0 85

prfd    pldl1strm, p0, [x0, #31, mul vl]
// CHECK-INST: prfd     pldl1strm, p0, [x0, #31, mul vl]
// CHECK-ENCODING: [0x01,0x60,0xdf,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 01 60 df 85

prfd    pldl1keep, p0, [x0, z0.s, uxtw #3]
// CHECK-INST: prfd    pldl1keep, p0, [x0, z0.s, uxtw #3]
// CHECK-ENCODING: [0x00,0x60,0x20,0x84]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 20 84 <unknown>

prfd    pldl1keep, p0, [x0, z0.s, sxtw #3]
// CHECK-INST: prfd    pldl1keep, p0, [x0, z0.s, sxtw #3]
// CHECK-ENCODING: [0x00,0x60,0x60,0x84]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 60 84 <unknown>

prfd    pldl1keep, p0, [x0, z0.d, uxtw #3]
// CHECK-INST: prfd    pldl1keep, p0, [x0, z0.d, uxtw #3]
// CHECK-ENCODING: [0x00,0x60,0x20,0xc4]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 20 c4 <unknown>

prfd    pldl1keep, p0, [x0, z0.d, sxtw #3]
// CHECK-INST: prfd    pldl1keep, p0, [x0, z0.d, sxtw #3]
// CHECK-ENCODING: [0x00,0x60,0x60,0xc4]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 60 60 c4 <unknown>

prfd    pldl1keep, p0, [x0, z0.d, lsl #3]
// CHECK-INST: prfd    pldl1keep, p0, [x0, z0.d, lsl #3]
// CHECK-ENCODING: [0x00,0xe0,0x60,0xc4]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 e0 60 c4 <unknown>

prfd    #15, p7, [z31.s, #0]
// CHECK-INST: prfd    #15, p7, [z31.s]
// CHECK-ENCODING: [0xef,0xff,0x80,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef ff 80 85 <unknown>

prfd    #15, p7, [z31.s, #248]
// CHECK-INST: prfd    #15, p7, [z31.s, #248]
// CHECK-ENCODING: [0xef,0xff,0x9f,0x85]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef ff 9f 85 <unknown>

prfd    #15, p7, [z31.d, #0]
// CHECK-INST: prfd    #15, p7, [z31.d]
// CHECK-ENCODING: [0xef,0xff,0x80,0xc5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef ff 80 c5 <unknown>

prfd    #15, p7, [z31.d, #248]
// CHECK-INST: prfd    #15, p7, [z31.d, #248]
// CHECK-ENCODING: [0xef,0xff,0x9f,0xc5]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef ff 9f c5 <unknown>
