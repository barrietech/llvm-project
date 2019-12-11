//===-- Config.h -----------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_HOST_CONFIG_H
#define LLDB_HOST_CONFIG_H

#cmakedefine LLDB_CONFIG_TERMIOS_SUPPORTED

#cmakedefine01 LLDB_EDITLINE_USE_WCHAR

#cmakedefine01 LLDB_HAVE_EL_RFUNC_T

#cmakedefine LLDB_DISABLE_POSIX

#cmakedefine01 HAVE_SYS_TYPES_H

#cmakedefine01 HAVE_SYS_EVENT_H

#cmakedefine01 HAVE_PPOLL

#cmakedefine01 HAVE_SIGACTION

#cmakedefine01 HAVE_PROCESS_VM_READV

#cmakedefine01 HAVE_NR_PROCESS_VM_READV

#ifndef HAVE_LIBCOMPRESSION
#cmakedefine HAVE_LIBCOMPRESSION
#endif

#cmakedefine01 LLDB_ENABLE_LZMA

#cmakedefine LLDB_DISABLE_CURSES

#cmakedefine LLDB_DISABLE_LIBEDIT

#cmakedefine LLDB_DISABLE_PYTHON

#cmakedefine LLDB_PYTHON_HOME "${LLDB_PYTHON_HOME}"

#define LLDB_LIBDIR_SUFFIX "${LLVM_LIBDIR_SUFFIX}"

#endif // #ifndef LLDB_HOST_CONFIG_H
