# RUN: llvm-mc -triple=wasm32-unknown-unknown -filetype=obj %s | llvm-objdump -t - | FileCheck %s

.section    .data,"",@
foo:
  .int32 0
  .size foo, 4
sym_a:
  .int32 1
  .int32 2
  .size sym_a, 8

.set sym_b, sym_a + 4

# CHECK: 00000000 l     O DATA foo
# CHECK: 00000004 l     O DATA sym_a
# CHECK: 00000008 l     O DATA sym_b
