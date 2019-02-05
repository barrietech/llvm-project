//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// type_traits

// void

#include <type_traits>
#include "test_macros.h"

template <class T>
void test_void_imp()
{
    static_assert( std::is_void<T>::value, "");
#if TEST_STD_VER > 11
    static_assert(!std::is_null_pointer<T>::value, "");
#endif
    static_assert(!std::is_integral<T>::value, "");
    static_assert(!std::is_floating_point<T>::value, "");
    static_assert(!std::is_array<T>::value, "");
    static_assert(!std::is_pointer<T>::value, "");
    static_assert(!std::is_lvalue_reference<T>::value, "");
    static_assert(!std::is_rvalue_reference<T>::value, "");
    static_assert(!std::is_member_object_pointer<T>::value, "");
    static_assert(!std::is_member_function_pointer<T>::value, "");
    static_assert(!std::is_enum<T>::value, "");
    static_assert(!std::is_union<T>::value, "");
    static_assert(!std::is_class<T>::value, "");
    static_assert(!std::is_function<T>::value, "");
}

template <class T>
void test_void()
{
    test_void_imp<T>();
    test_void_imp<const T>();
    test_void_imp<volatile T>();
    test_void_imp<const volatile T>();
}

struct incomplete_type;

int main(int, char**)
{
    test_void<void>();

//  LWG#2582
    static_assert(!std::is_void<incomplete_type>::value, "");

  return 0;
}
