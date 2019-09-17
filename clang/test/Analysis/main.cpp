// RUN: %clang_analyze_cc1 -analyzer-checker=core,debug.ExprInspection -verify %s

int x = 1;

struct {
  int a, b;
} s = {2, 3};

int arr[] = {4, 5, 6};

void clang_analyzer_eval(int);

int main() {
  // Do not trust global initializers in C++.
  clang_analyzer_eval(x == 1); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  clang_analyzer_eval(s.a == 2); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  clang_analyzer_eval(s.b == 3); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  clang_analyzer_eval(arr[0] == 4); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  clang_analyzer_eval(arr[1] == 5); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  clang_analyzer_eval(arr[2] == 6); // expected-warning{{TRUE}} // expected-warning{{FALSE}}
  return 0;
}
