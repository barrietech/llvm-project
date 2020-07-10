//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14

// This test segfaults GCC 5
// UNSUPPORTED: gcc-5

// <optional>

// optional<T>& operator=(optional<T>&& rhs);

#include <optional>
#include <string>
#include <type_traits>
#include <utility>

#include "test_macros.h"

using std::optional;

struct X {};

struct Y
{
    Y() = default;
    Y& operator=(Y&&) { return *this; }
};

struct Z1
{
    Z1() = default;
    Z1(Z1&&) = default;
    Z1& operator=(Z1&&) = delete;
};

struct Z2
{
    Z2() = default;
    Z2(Z2&&) = delete;
    Z2& operator=(Z2&&) = default;
};

template <class T>
constexpr bool
test()
{
    optional<T> opt;
    optional<T> opt2;
    opt = std::move(opt2);
    return true;
}

int main(int, char**)
{
    {
        using T = int;
        static_assert((std::is_trivially_copy_constructible<optional<T>>::value), "");
        static_assert(test<T>(), "");
    }
    {
        using T = X;
        static_assert((std::is_trivially_copy_constructible<optional<T>>::value), "");
        static_assert(test<T>(), "");
    }
    static_assert(!(std::is_trivially_move_assignable<optional<Y>>::value), "");
    static_assert(!(std::is_trivially_move_assignable<optional<std::string>>::value), "");

    static_assert(!(std::is_move_assignable<optional<Z1>>::value), "");
    static_assert(!(std::is_move_assignable<optional<Z2>>::value), "");

  return 0;
}
