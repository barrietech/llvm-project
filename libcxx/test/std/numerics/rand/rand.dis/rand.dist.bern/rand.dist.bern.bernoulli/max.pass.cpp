//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <random>

// class bernoulli_distribution

// result_type max() const;

#include <random>
#include <cassert>

int main(int, char**)
{
    {
        typedef std::bernoulli_distribution D;
        D d(.25);
        assert(d.max() == true);
    }

  return 0;
}
