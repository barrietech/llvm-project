//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___ALGORITHM_PSTL_BACKENDS_OPENMP_BACKEND_TRANSFORM_REDUCE_H
#define _LIBCPP___ALGORITHM_PSTL_BACKENDS_OPENMP_BACKEND_TRANSFORM_REDUCE_H

#include <__algorithm/pstl_backends/cpu_backends/backend.h>
#include <__algorithm/pstl_backends/openmp/backend.h>
#include <__algorithm/unwrap_iter.h>
#include <__config>
#include <__functional/operations.h>
#include <__iterator/concepts.h>
#include <__iterator/wrap_iter.h>
#include <__numeric/transform_reduce.h>
#include <__type_traits/integral_constant.h>
#include <__type_traits/is_arithmetic.h>
#include <__type_traits/is_execution_policy.h>
#include <__type_traits/operation_traits.h>
#include <optional>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

#if !defined(_LIBCPP_HAS_NO_INCOMPLETE_PSTL) && _LIBCPP_STD_VER >= 17

_LIBCPP_BEGIN_NAMESPACE_STD

//===----------------------------------------------------------------------===//
// Templates for predefined reductions
//===----------------------------------------------------------------------===//

#  define __PSTL_OMP_SIMD_1_REDUCTION(omp_op, std_op)                                                                  \
    template <class _Iterator,                                                                                         \
              class _DifferenceType,                                                                                   \
              typename _Tp,                                                                                            \
              typename _BinaryOperationType,                                                                           \
              typename _UnaryOperation>                                                                                \
    _LIBCPP_HIDE_FROM_ABI _Tp __omp_transform_reduce(                                                                  \
        _Iterator __first,                                                                                             \
        _DifferenceType __n,                                                                                           \
        _Tp __init,                                                                                                    \
        std_op<_BinaryOperationType> __reduce,                                                                         \
        _UnaryOperation __transform) noexcept {                                                                        \
      __par_backend::__omp_map_to(__first, __n);                                                                       \
_PSTL_PRAGMA(omp target teams distribute parallel for simd reduction(omp_op:__init))                                   \
      for (_DifferenceType __i = 0; __i < __n; ++__i)                                                                  \
        __init = __reduce(__init, __transform(*(__first + __i)));                                                      \
      __par_backend::__omp_map_release(__first, __n);                                                                  \
      return __init;                                                                                                   \
    }

#  define __PSTL_OMP_SIMD_2_REDUCTION(omp_op, std_op)                                                                  \
    template <class _Iterator1,                                                                                        \
              class _Iterator2,                                                                                        \
              class _DifferenceType,                                                                                   \
              typename _Tp,                                                                                            \
              typename _BinaryOperationType,                                                                           \
              typename _UnaryOperation >                                                                               \
    _LIBCPP_HIDE_FROM_ABI _Tp __omp_transform_reduce(                                                                  \
        _Iterator1 __first1,                                                                                           \
        _Iterator2 __first2,                                                                                           \
        _DifferenceType __n,                                                                                           \
        _Tp __init,                                                                                                    \
        std_op<_BinaryOperationType> __reduce,                                                                         \
        _UnaryOperation __transform) noexcept {                                                                        \
      __par_backend::__omp_map_to(__first1, __n);                                                                      \
      __par_backend::__omp_map_to(__first2, __n);                                                                      \
_PSTL_PRAGMA(omp target teams distribute parallel for simd reduction(omp_op:__init))                                   \
      for (_DifferenceType __i = 0; __i < __n; ++__i)                                                                  \
        __init = __reduce(__init, __transform(*(__first1 + __i), *(__first2 + __i)));                                  \
      __par_backend::__omp_map_release(__first1, __n);                                                                 \
      __par_backend::__omp_map_release(__first2, __n);                                                                 \
      return __init;                                                                                                   \
    }

#  define __PSTL_OMP_SIMD_REDUCTION(omp_op, std_op)                                                                    \
    __PSTL_OMP_SIMD_1_REDUCTION(omp_op, std_op)                                                                        \
    __PSTL_OMP_SIMD_2_REDUCTION(omp_op, std_op)

// Addition
__PSTL_OMP_SIMD_REDUCTION(+, std::plus)

// Subtraction
__PSTL_OMP_SIMD_REDUCTION(-, std::minus)

// Multiplication
__PSTL_OMP_SIMD_REDUCTION(*, std::multiplies)

// Logical and
__PSTL_OMP_SIMD_REDUCTION(&&, std::logical_and)

// Logical or
__PSTL_OMP_SIMD_REDUCTION(||, std::logical_or)

// Bitwise and
__PSTL_OMP_SIMD_REDUCTION(&, std::bit_and)

// Bitwise or
__PSTL_OMP_SIMD_REDUCTION(|, std::bit_or)

// Bitwise xor
__PSTL_OMP_SIMD_REDUCTION(^, std::bit_xor)

//===----------------------------------------------------------------------===//
// The following struct is used to determine whether a reduction is supported by
// the OpenMP backend.
//===----------------------------------------------------------------------===//

template <class _T1, class _T2, class _T3>
struct __is_supported_reduction : std::false_type {};

#  define __PSTL_IS_SUPPORTED_REDUCTION(funname)                                                                       \
    template <class _Tp>                                                                                               \
    struct __is_supported_reduction<std::funname<_Tp>, _Tp, _Tp> : std::true_type {};                                  \
    template <class _Tp, class _Up>                                                                                    \
    struct __is_supported_reduction<std::funname<>, _Tp, _Up> : std::true_type {};

// __is_trivial_plus_operation already exists
__PSTL_IS_SUPPORTED_REDUCTION(plus)
__PSTL_IS_SUPPORTED_REDUCTION(minus)
__PSTL_IS_SUPPORTED_REDUCTION(multiplies)
__PSTL_IS_SUPPORTED_REDUCTION(logical_and)
__PSTL_IS_SUPPORTED_REDUCTION(logical_or)
__PSTL_IS_SUPPORTED_REDUCTION(bit_and)
__PSTL_IS_SUPPORTED_REDUCTION(bit_or)
__PSTL_IS_SUPPORTED_REDUCTION(bit_xor)

//===----------------------------------------------------------------------===//
// Implementation of PSTL transform_reduce for one and two input iterators
//===----------------------------------------------------------------------===//

template <class _ExecutionPolicy, class _ForwardIterator, class _Tp, class _BinaryOperation, class _UnaryOperation>
_LIBCPP_HIDE_FROM_ABI optional<_Tp> __pstl_transform_reduce(
    __omp_backend_tag,
    _ForwardIterator __first,
    _ForwardIterator __last,
    _Tp __init,
    _BinaryOperation __reduce,
    _UnaryOperation __transform) {
  if constexpr (__is_unsequenced_execution_policy_v<_ExecutionPolicy> &&
                __is_parallel_execution_policy_v<_ExecutionPolicy> &&
                __libcpp_is_contiguous_iterator<_ForwardIterator>::value && is_arithmetic_v<_Tp> &&
                __is_supported_reduction<_BinaryOperation, _Tp, _Tp>::value) {
    return std::__omp_transform_reduce(std::__unwrap_iter(__first), __last - __first, __init, __reduce, __transform);
  }
  return std::__pstl_transform_reduce<_ExecutionPolicy>(
      __cpu_backend_tag{}, __first, __last, std::move(__init), __reduce, __transform);
}

template <class _ExecutionPolicy,
          class _ForwardIterator1,
          class _ForwardIterator2,
          class _Tp,
          class _BinaryOperation1,
          class _BinaryOperation2>
_LIBCPP_HIDE_FROM_ABI optional<_Tp> __pstl_transform_reduce(
    __omp_backend_tag,
    _ForwardIterator1 __first1,
    _ForwardIterator1 __last1,
    _ForwardIterator2 __first2,
    _Tp __init,
    _BinaryOperation1 __reduce,
    _BinaryOperation2 __transform) {
  if constexpr (__is_unsequenced_execution_policy_v<_ExecutionPolicy> &&
                __is_parallel_execution_policy_v<_ExecutionPolicy> &&
                __libcpp_is_contiguous_iterator<_ForwardIterator1>::value &&
                __libcpp_is_contiguous_iterator<_ForwardIterator2>::value && is_arithmetic_v<_Tp> &&
                __is_supported_reduction<_BinaryOperation1, _Tp, _Tp>::value) {
    return std::__omp_transform_reduce(
        std::__unwrap_iter(__first1), std::__unwrap_iter(__first2), __last1 - __first1, __init, __reduce, __transform);
  }
  return std::__pstl_transform_reduce<_ExecutionPolicy>(
      __cpu_backend_tag{}, __first1, __last1, __first2, std::move(__init), __reduce, __transform);
}

_LIBCPP_END_NAMESPACE_STD

#endif // !defined(_LIBCPP_HAS_NO_INCOMPLETE_PSTL) && _LIBCPP_STD_VER >= 17

#endif // _LIBCPP___ALGORITHM_PSTL_BACKENDS_OPENMP_BACKEND_TRANSFORM_REDUCE_H
