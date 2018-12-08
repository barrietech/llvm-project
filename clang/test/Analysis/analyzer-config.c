// RUN: %clang_analyze_cc1 -triple x86_64-apple-darwin10 %s -o /dev/null -analyzer-checker=core,osx.cocoa,debug.ConfigDumper -analyzer-max-loop 34 > %t 2>&1
// RUN: FileCheck --input-file=%t %s --match-full-lines

// CHECK: [config]
// CHECK-NEXT: aggressive-binary-operation-simplification = false
// CHECK-NEXT: avoid-suppressing-null-argument-paths = false
// CHECK-NEXT: c++-allocator-inlining = true
// CHECK-NEXT: c++-container-inlining = false
// CHECK-NEXT: c++-inlining = destructors
// CHECK-NEXT: c++-shared_ptr-inlining = false
// CHECK-NEXT: c++-stdlib-inlining = true
// CHECK-NEXT: c++-temp-dtor-inlining = true
// CHECK-NEXT: c++-template-inlining = true
// CHECK-NEXT: cfg-conditional-static-initializers = true
// CHECK-NEXT: cfg-implicit-dtors = true
// CHECK-NEXT: cfg-lifetime = false
// CHECK-NEXT: cfg-loopexit = false
// CHECK-NEXT: cfg-rich-constructors = true
// CHECK-NEXT: cfg-scopes = false
// CHECK-NEXT: cfg-temporary-dtors = true
// CHECK-NEXT: crosscheck-with-z3 = false
// CHECK-NEXT: ctu-dir = ""
// CHECK-NEXT: ctu-index-name = externalFnMap.txt
// CHECK-NEXT: display-ctu-progress = false
// CHECK-NEXT: eagerly-assume = true
// CHECK-NEXT: elide-constructors = true
// CHECK-NEXT: expand-macros = false
// CHECK-NEXT: experimental-enable-naive-ctu-analysis = false
// CHECK-NEXT: exploration_strategy = unexplored_first_queue
// CHECK-NEXT: faux-bodies = true
// CHECK-NEXT: graph-trim-interval = 1000
// CHECK-NEXT: inline-lambdas = true
// CHECK-NEXT: ipa = dynamic-bifurcate
// CHECK-NEXT: ipa-always-inline-size = 3
// CHECK-NEXT: max-inlinable-size = 100
// CHECK-NEXT: max-nodes = 225000
// CHECK-NEXT: max-symbol-complexity = 35
// CHECK-NEXT: max-times-inline-large = 32
// CHECK-NEXT: min-cfg-size-treat-functions-as-large = 14
// CHECK-NEXT: mode = deep
// CHECK-NEXT: model-path = ""
// CHECK-NEXT: notes-as-events = false
// CHECK-NEXT: objc-inlining = true
// CHECK-NEXT: prune-paths = true
// CHECK-NEXT: region-store-small-struct-limit = 2
// CHECK-NEXT: report-in-main-source-file = false
// CHECK-NEXT: serialize-stats = false
// CHECK-NEXT: stable-report-filename = false
// CHECK-NEXT: suppress-c++-stdlib = true
// CHECK-NEXT: suppress-inlined-defensive-checks = true
// CHECK-NEXT: suppress-null-return-paths = true
// CHECK-NEXT: unroll-loops = false
// CHECK-NEXT: widen-loops = false
// CHECK-NEXT: [stats]
// CHECK-NEXT: num-entries = 49
