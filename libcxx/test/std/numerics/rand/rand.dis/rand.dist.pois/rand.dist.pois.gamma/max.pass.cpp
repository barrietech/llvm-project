//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <random>

// template<class RealType = double>
// class gamma_distribution

// result_type max() const;

#include <random>
#include <cassert>

int main(int, char**)
{
    {
        typedef std::gamma_distribution<> D;
        D d(5, .25);
        D::result_type m = d.max();
        assert(m == INFINITY);
    }

  return 0;
}
