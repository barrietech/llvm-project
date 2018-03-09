# REQUIRES: x86

# RUN: llvm-mc -filetype=obj -triple=x86_64-pc-linux %s -o %t.o
# RUN: not ld.lld %t.o -o %t 2>&1 | FileCheck %s

## Check we do not crash and report proper errors.
# CHECK: error: a section .bar with SHF_LINK_ORDER should not refer a non-regular section: {{.*}}section-metadata-err2.s.tmp.o:(.foo)
# CHECK: error: a section .bar with SHF_LINK_ORDER should not refer a non-regular section: {{.*}}section-metadata-err2.s.tmp.o:(.foo)

.section .foo,"aM",@progbits,8
.quad 0

.section .bar,"ao",@progbits,.foo,unique,1
.quad 0

.section .bar,"ao",@progbits,.foo,unique,2
.quad 1
