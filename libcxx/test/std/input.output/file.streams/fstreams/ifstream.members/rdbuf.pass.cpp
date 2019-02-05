//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <fstream>

// template <class charT, class traits = char_traits<charT> >
// class basic_ifstream

// basic_filebuf<charT,traits>* rdbuf() const;

#include <fstream>
#include <cassert>

int main(int, char**)
{
    {
        std::ifstream fs("test.dat");
        std::filebuf* fb = fs.rdbuf();
        assert(fb->sgetc() == 'r');
    }
    {
        std::wifstream fs("test.dat");
        std::wfilebuf* fb = fs.rdbuf();
        assert(fb->sgetc() == L'r');
    }

  return 0;
}
