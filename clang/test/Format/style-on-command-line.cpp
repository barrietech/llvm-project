// RUN: clang-format -style="{BasedOnStyle: Google, IndentWidth: 8}" %s | FileCheck -strict-whitespace -check-prefix=CHECK1 %s
// RUN: clang-format -style="{BasedOnStyle: LLVM, IndentWidth: 7}" %s | FileCheck -strict-whitespace -check-prefix=CHECK2 %s
// RUN: not clang-format -style="{BasedOnStyle: invalid, IndentWidth: 7}" -fallback-style=LLVM %s 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK3 %s
// RUN: not clang-format -style="{lsjd}" %s -fallback-style=LLVM 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK4 %s
// RUN: printf "BasedOnStyle: google\nIndentWidth: 5\n" > %T/.clang-format
// RUN: clang-format -style=file -assume-filename=%T/foo.cpp < %s | FileCheck -strict-whitespace -check-prefix=CHECK5 %s
// RUN: printf "\n" > %T/.clang-format
// RUN: not clang-format -style=file -fallback-style=webkit -assume-filename=%T/foo.cpp < %s 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK6 %s
// RUN: rm %T/.clang-format
// RUN: printf "BasedOnStyle: google\nIndentWidth: 6\n" > %T/_clang-format
// RUN: clang-format -style=file -assume-filename=%T/foo.cpp < %s | FileCheck -strict-whitespace -check-prefix=CHECK7 %s
// RUN: clang-format -style="{BasedOnStyle: LLVM, PointerBindsToType: true}" %s | FileCheck -strict-whitespace -check-prefix=CHECK8 %s
// RUN: clang-format -style="{BasedOnStyle: WebKit, PointerBindsToType: false}" %s | FileCheck -strict-whitespace -check-prefix=CHECK9 %s

// Fallback style tests
// RUN: rm %T/_clang-format
// Test no config file found, WebKit fallback style is applied
// RUN: clang-format -style=file -fallback-style=WebKit -assume-filename=%T/foo.cpp < %s 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK10 %s
// Test no config file and fallback style "none", no formatting is applied
// RUN: clang-format -style=file -fallback-style=none -assume-filename=%T/foo.cpp < %s 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK11 %s
// Test config file with no based style, and fallback style "none", formatting is applied
// RUN: printf "IndentWidth: 6\n" > %T/_clang-format
// RUN: clang-format -style=file -fallback-style=none -assume-filename=%T/foo.cpp < %s 2>&1 | FileCheck -strict-whitespace -check-prefix=CHECK12 %s
// Test yaml with no based style, and fallback style "none", LLVM formatting applied
// RUN: clang-format -style="{IndentWidth: 7}" -fallback-style=none %s | FileCheck -strict-whitespace -check-prefix=CHECK13 %s

void f() {
// CHECK1: {{^        int\* i;$}}
// CHECK2: {{^       int \*i;$}}
// CHECK3: Unknown value for BasedOnStyle: invalid
// CHECK3: Error parsing -style: {{I|i}}nvalid argument
// CHECK4: Error parsing -style: {{I|i}}nvalid argument
// CHECK5: {{^     int\* i;$}}
// CHECK6: {{^Error reading .*\.clang-format: (I|i)nvalid argument}}
// CHECK7: {{^      int\* i;$}}
// CHECK8: {{^  int\* i;$}}
// CHECK9: {{^    int \*i;$}}
// CHECK10: {{^    int\* i;$}}
// CHECK11: {{^int\*i;$}}
// CHECK12: {{^      int \*i;$}}
// CHECK13: {{^       int \*i;$}}
int*i;
int j;
}

// On Windows, the 'rm' commands fail when the previous process is still alive.
// This happens enough to make the test useless.
// REQUIRES: shell
