// RUN: %strip_comments > %t.stripped.cpp
// RUN: %clang_cc1 -std=c++11 -fprofile-instrument=clang -fcoverage-mapping -dump-coverage-mapping -emit-llvm-only -main-file-name loops.cpp %t.stripped.cpp | FileCheck %s

// CHECK: rangedFor
void rangedFor() {                  // CHECK-NEXT: File 0, [[@LINE]]:18 -> {{[0-9]+}}:2 = #0
  int arr[] = { 1, 2, 3, 4, 5 };
  int sum = 0;                      // CHECK: Gap,File 0, [[@LINE+1]]:20 -> [[@LINE+1]]:21 = #1
  for(auto i : arr) {               // CHECK: File 0, [[@LINE]]:21 -> [[@LINE+6]]:4 = #1
    if (i == 3)
      continue;                     // CHECK: File 0, [[@LINE]]:7 -> [[@LINE]]:15 = #2
    sum += i;                       // CHECK: File 0, [[@LINE]]:5 -> {{[0-9]+}}:4 = (#1 - #2)
    if (sum >= 7)
      break;                        // CHECK: File 0, [[@LINE]]:7 -> [[@LINE]]:12 = #3
  }

  // CHECK: File 0, [[@LINE+1]]:7 -> [[@LINE+1]]:10 = #0
  if (sum) {}
}

                                    // CHECK: main:
int main() {                        // CHECK-NEXT: File 0, [[@LINE]]:12 -> {{.*}}:2 = #0
                                    // CHECK-NEXT: File 0, [[@LINE+1]]:18 -> [[@LINE+1]]:24 = (#0 + #1)
  for(int i = 0; i < 10; ++i)       // CHECK-NEXT: File 0, [[@LINE]]:26 -> [[@LINE]]:29 = #1
     ;                              // CHECK-NEXT: Gap,File 0, [[@LINE-1]]:30 -> [[@LINE]]:6 = #1
                                    // CHECK-NEXT: File 0, [[@LINE-1]]:6 -> [[@LINE-1]]:7 = #1
  for(int i = 0;
      i < 10;                       // CHECK-NEXT: File 0, [[@LINE]]:7 -> [[@LINE]]:13 = (#0 + #2)
      ++i)                          // CHECK-NEXT: File 0, [[@LINE]]:7 -> [[@LINE]]:10 = #2
  {                                 // CHECK-NEXT: Gap,File 0, [[@LINE-1]]:11 -> [[@LINE]]:3 = #2
    int x = 0;                      // CHECK-NEXT: File 0, [[@LINE-1]]:3 -> [[@LINE+1]]:4 = #2
  }
  int j = 0;                        // CHECK-NEXT: File 0, [[@LINE+1]]:9 -> [[@LINE+1]]:14 = (#0 + #3)
  while(j < 5) ++j;                 // CHECK-NEXT: Gap,File 0, [[@LINE]]:15 -> [[@LINE]]:16 = #3
                                    // CHECK-NEXT: File 0, [[@LINE-1]]:16 -> [[@LINE-1]]:19 = #3

  do {                              // CHECK-NEXT: File 0, [[@LINE]]:6 -> [[@LINE+2]]:4 = (#0 + #4)
    ++j;
  } while(j < 10);                  // CHECK-NEXT: File 0, [[@LINE]]:11 -> [[@LINE]]:17 = (#0 + #4)
  j = 0;
  while                             // CHECK-NEXT: File 0, [[@LINE+1]]:5 -> [[@LINE+1]]:10 = (#0 + #5)
   (j < 5)                          // CHECK-NEXT: Gap,File 0, [[@LINE]]:11 -> [[@LINE+1]]:6 = #5
     ++j;                           // CHECK-NEXT: File 0, [[@LINE]]:6 -> [[@LINE]]:9 = #5
  do
    ++j;                            // CHECK-NEXT: File 0, [[@LINE]]:5 -> [[@LINE]]:8 = (#0 + #6)
  while(j < 10);                    // CHECK-NEXT: File 0, [[@LINE]]:9 -> [[@LINE]]:15 = (#0 + #6)
  rangedFor();
  return 0;
}
