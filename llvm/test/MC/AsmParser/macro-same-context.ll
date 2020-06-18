;; Test that macros in inline assembly blocks share the same context,
;; thus a definition is available to the whole file. PR36110
; RUN: not llc < %s 2>&1 | FileCheck %s
; REQUIRES: default_triple
;; This test is expected to fail on AIX,
;; since the integrated assembly parser was not implemented yet for AIX.
; XFAIL: aix

define void @test() {
  call void asm sideeffect ".macro FOO\0A.endm", "~{dirflag},~{fpsr},~{flags}"() #1
  call void asm sideeffect ".macro FOO\0A.endm", "~{dirflag},~{fpsr},~{flags}"() #1
; CHECK: error: macro 'FOO' is already defined
  ret void
}
