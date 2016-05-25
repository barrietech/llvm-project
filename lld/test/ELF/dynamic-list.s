## There is some bad quoting interaction between lit's internal shell, which is
## implemented in Python, and the Cygwin implementations of the Unix utilities.
## Avoid running these tests on Windows for now by requiring a real shell.

# REQUIRES: shell

# REQUIRES: x86

# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %p/Inputs/shared.s -o %t2.o
# RUN: ld.lld -shared %t2.o -soname shared -o %t2.so
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t

## Check exporting only one symbol.
# RUN: echo "{ foo1; };" > %t.list
# RUN: ld.lld --dynamic-list %t.list %t %t2.so -o %t.exe
# RUN: llvm-readobj -dyn-symbols %t.exe | FileCheck %s

## And now using quoted strings (the output is the same since it does
## use any wildcard character).
# RUN: echo "{ \"foo1\"; };" > %t.list
# RUN: ld.lld --dynamic-list %t.list %t %t2.so -o %t.exe
# RUN: llvm-readobj -dyn-symbols %t.exe | FileCheck %s

## And now using --export-dynamic-symbol.
# RUN: ld.lld --export-dynamic-symbol foo1 %t %t2.so -o %t.exe
# RUN: llvm-readobj -dyn-symbols %t.exe | FileCheck %s
# RUN: ld.lld --export-dynamic-symbol=foo1 %t %t2.so -o %t.exe
# RUN: llvm-readobj -dyn-symbols %t.exe | FileCheck %s

# CHECK:      DynamicSymbols [
# CHECK-NEXT:   Symbol {
# CHECK-NEXT:     Name: @ (0)
# CHECK-NEXT:     Value: 0x0
# CHECK-NEXT:     Size: 0
# CHECK-NEXT:     Binding: Local
# CHECK-NEXT:     Type: None
# CHECK-NEXT:     Other: 0
# CHECK-NEXT:     Section: Undefined
# CHECK-NEXT:   }
# CHECK-NEXT:   Symbol {
# CHECK-NEXT:     Name: foo1@ (1)
# CHECK-NEXT:     Value: 0x11000
# CHECK-NEXT:     Size: 0
# CHECK-NEXT:     Binding: Global (0x1)
# CHECK-NEXT:     Type: None (0x0)
# CHECK-NEXT:     Other: 0
# CHECK-NEXT:     Section: .text (0x4)
# CHECK-NEXT:   }
# CHECK-NEXT: ] 


## Now export all the foo1, foo2, and foo31 symbols
# RUN: echo "{ foo1; foo2; foo31; };" > %t.list
# RUN: ld.lld --dynamic-list %t.list %t %t2.so -o %t.exe
# RUN: llvm-readobj -dyn-symbols %t.exe | FileCheck -check-prefix=CHECK2 %s

# CHECK2:      DynamicSymbols [
# CHECK2-NEXT:   Symbol {
# CHECK2-NEXT:     Name: @ (0)
# CHECK2-NEXT:     Value: 0x0
# CHECK2-NEXT:     Size: 0
# CHECK2-NEXT:     Binding: Local
# CHECK2-NEXT:     Type: None
# CHECK2-NEXT:     Other: 0
# CHECK2-NEXT:     Section: Undefined
# CHECK2-NEXT:   }
# CHECK2-NEXT:   Symbol {
# CHECK2-NEXT:     Name: foo1@ (1)
# CHECK2-NEXT:     Value: 0x11000
# CHECK2-NEXT:     Size: 0
# CHECK2-NEXT:     Binding: Global (0x1)
# CHECK2-NEXT:     Type: None (0x0)
# CHECK2-NEXT:     Other: 0
# CHECK2-NEXT:     Section: .text (0x4)
# CHECK2-NEXT:   }
# CHECK2-NEXT:   Symbol {
# CHECK2-NEXT:     Name: foo2@ (6)
# CHECK2-NEXT:     Value: 0x11001
# CHECK2-NEXT:     Size: 0
# CHECK2-NEXT:     Binding: Global (0x1)
# CHECK2-NEXT:     Type: None (0x0)
# CHECK2-NEXT:     Other: 0
# CHECK2-NEXT:     Section: .text (0x4)
# CHECK2-NEXT:   }
# CHECK2-NEXT:   Symbol {
# CHECK2-NEXT:     Name: foo31@ (11)
# CHECK2-NEXT:     Value: 0x11002
# CHECK2-NEXT:     Size: 0
# CHECK2-NEXT:     Binding: Global (0x1)
# CHECK2-NEXT:     Type: None (0x0)
# CHECK2-NEXT:     Other: 0
# CHECK2-NEXT:     Section: .text (0x4)
# CHECK2-NEXT:   }
# CHECK2-NEXT: ] 

.globl foo1
foo1:
  ret

.globl foo2
foo2:
  ret

.globl foo31
foo31:
  ret

.globl _start
_start:
  retq
