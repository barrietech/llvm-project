//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14

// asan and msan will not call the new handler.
// UNSUPPORTED: sanitizer-new-delete

// Aligned allocation was not provided before macosx10.14 and as a result we
// get availability errors when the deployment target is older than macosx10.14.
// However, AppleClang 10 (and older) don't trigger availability errors, and
// Clang < 8.0 doesn't warn for 10.13.
// XFAIL: !(apple-clang-9 || apple-clang-10 || clang-7) && availability=macosx10.13
// XFAIL: !(apple-clang-9 || apple-clang-10) && availability=macosx10.12
// XFAIL: !(apple-clang-9 || apple-clang-10) && availability=macosx10.11
// XFAIL: !(apple-clang-9 || apple-clang-10) && availability=macosx10.10
// XFAIL: !(apple-clang-9 || apple-clang-10) && availability=macosx10.9

// On AppleClang 10 (and older), instead of getting an availability failure
// like above, we get a link error when we link against a dylib that does
// not export the aligned allocation functions.
// XFAIL: (apple-clang-9 || apple-clang-10) && with_system_cxx_lib=macosx10.12
// XFAIL: (apple-clang-9 || apple-clang-10) && with_system_cxx_lib=macosx10.11
// XFAIL: (apple-clang-9 || apple-clang-10) && with_system_cxx_lib=macosx10.10
// XFAIL: (apple-clang-9 || apple-clang-10) && with_system_cxx_lib=macosx10.9

// On Windows libc++ doesn't provide its own definitions for new/delete
// but instead depends on the ones in VCRuntime. However VCRuntime does not
// yet provide aligned new/delete definitions so this test fails to compile/link.
// XFAIL: LIBCXX-WINDOWS-FIXME

// test operator new (nothrow)

#include <new>
#include <cstddef>
#include <cstdint>
#include <cassert>
#include <limits>

#include "test_macros.h"

constexpr auto OverAligned = __STDCPP_DEFAULT_NEW_ALIGNMENT__ * 2;

int new_handler_called = 0;

void my_new_handler()
{
    ++new_handler_called;
    std::set_new_handler(0);
}

int A_constructed = 0;

struct alignas(OverAligned) A
{
    A() { ++A_constructed; }
    ~A() { --A_constructed; }
};

void test_max_alloc() {
    std::set_new_handler(my_new_handler);
    auto do_test = []() {
        void* vp = operator new [](std::numeric_limits<std::size_t>::max(),
                                 std::align_val_t(OverAligned),
                                 std::nothrow);
        assert(new_handler_called == 1);
        assert(vp == 0);
    };
#ifndef TEST_HAS_NO_EXCEPTIONS
    try
    {
        do_test();
    }
    catch (...)
    {
        assert(false);
    }
#else
    do_test();
#endif
}

int main(int, char**)
{
    {
        A* ap = new(std::nothrow) A[3];
        assert(ap);
        assert(reinterpret_cast<std::uintptr_t>(ap) % OverAligned == 0);
        assert(A_constructed == 3);
        delete [] ap;
        assert(!A_constructed);
    }
    {
        test_max_alloc();
    }

  return 0;
}
