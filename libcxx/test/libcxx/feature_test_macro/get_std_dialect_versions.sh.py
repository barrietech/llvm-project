# RUN: %{python} %s %{libcxx-dir}/utils %{libcxx-dir}/utils/data/feature_test_macros/test_data.json
# ===----------------------------------------------------------------------===##
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# ===----------------------------------------------------------------------===##

import sys

sys.path.append(sys.argv[1])
from generate_feature_test_macro_components import feature_test_macros


def test(output, expected):
    assert output == expected, f"expected\n{expected}\n\noutput\n{output}"


fmt = feature_test_macros(sys.argv[2])
test(
    fmt.get_std_dialect_versions(),
    {
        "__cpp_lib_any": {
            "c++17": "201606L",
            "c++20": "201606L",
            "c++23": "201606L",
            "c++26": "201606L",
        },
        "__cpp_lib_barrier": {
            "c++20": "201907L",
            "c++23": "201907L",
            "c++26": "201907L",
        },
        "__cpp_lib_format": {
            "c++20": "202110L",
            "c++23": "202207L",
            "c++26": "202311L",
        },
        "__cpp_lib_parallel_algorithm": {
            "c++17": "201603L",
            "c++20": "201603L",
            "c++23": "201603L",
            "c++26": "201603L",
        },
        "__cpp_lib_variant": {
            "c++17": "202102L",
            "c++20": "202106L",
            "c++23": "202106L",
            "c++26": "202306L",
        },
    },
)
