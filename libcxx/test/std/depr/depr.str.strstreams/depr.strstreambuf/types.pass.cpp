//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <strstream>

// class strstreambuf
//     : public basic_streambuf<char>

#include <strstream>
#include <type_traits>

int main(int, char**)
{
    static_assert((std::is_base_of<std::streambuf, std::strstreambuf>::value), "");

  return 0;
}
