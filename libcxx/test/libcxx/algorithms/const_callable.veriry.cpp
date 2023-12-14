//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <algorithm>

struct ConstUncallable {
  void operator()(int, int) const& = delete;
  void operator()(int, int) & { return; }
};

struct NonConstUncallable {
  void operator()(int, int) const& { return; }
  void operator()(int, int) & = delete;
};

void test() {
  std::minmax({42, 0, -42}, ConstUncallable{});
  //expected-error-re@*:* {{static_assert(__is_callable<_Compare const&, decltype(*__first), const _Tp&>::value, "The comparator has to be const-callable")}}
}
