//===-- Windows.cpp -------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// This file provides Windows support functions

#include "lldb/Host/PosixApi.h"
#include "lldb/Host/windows/windows.h"

#include "llvm/Support/ConvertUTF.h"

#include <assert.h>
#include <cerrno>
#include <ctype.h>
#include <io.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

namespace {
bool utf8ToWide(const char *utf8, wchar_t *buf, size_t bufSize) {
  const llvm::UTF8 *sourceStart = reinterpret_cast<const llvm::UTF8 *>(utf8);
  size_t sourceLen = strlen(utf8) + 1 /* convert null too */;
  llvm::UTF16 *target = reinterpret_cast<llvm::UTF16 *>(buf);
  llvm::ConversionFlags flags = llvm::strictConversion;
  return llvm::ConvertUTF8toUTF16(&sourceStart, sourceStart + sourceLen, &target,
                            target + bufSize, flags) == llvm::conversionOK;
}

bool wideToUtf8(const wchar_t *wide, char *buf, size_t bufSize) {
  const llvm::UTF16 *sourceStart = reinterpret_cast<const llvm::UTF16 *>(wide);
  size_t sourceLen = wcslen(wide) + 1 /* convert null too */;
  llvm::UTF8 *target = reinterpret_cast<llvm::UTF8 *>(buf);
  llvm::ConversionFlags flags = llvm::strictConversion;
  return llvm::ConvertUTF16toUTF8(&sourceStart, sourceStart + sourceLen, &target,
                            target + bufSize, flags) == llvm::conversionOK;
}
}

int vasprintf(char **ret, const char *fmt, va_list ap) {
  char *buf;
  int len;
  size_t buflen;
  va_list ap2;

  va_copy(ap2, ap);
  len = vsnprintf(NULL, 0, fmt, ap2);

  if (len >= 0 &&
      (buf = (char *)malloc((buflen = (size_t)(len + 1)))) != NULL) {
    len = vsnprintf(buf, buflen, fmt, ap);
    *ret = buf;
  } else {
    *ret = NULL;
    len = -1;
  }

  va_end(ap2);
  return len;
}

char *strcasestr(const char *s, const char *find) {
  char c, sc;
  size_t len;

  if ((c = *find++) != 0) {
    c = tolower((unsigned char)c);
    len = strlen(find);
    do {
      do {
        if ((sc = *s++) == 0)
          return 0;
      } while ((char)tolower((unsigned char)sc) != c);
    } while (strncasecmp(s, find, len) != 0);
    s--;
  }
  return const_cast<char *>(s);
}

#ifdef _MSC_VER

char *basename(char *path) {
  char *l1 = strrchr(path, '\\');
  char *l2 = strrchr(path, '/');
  if (l2 > l1)
    l1 = l2;
  if (!l1)
    return path; // no base name
  return &l1[1];
}

char *dirname(char *path) {
  char *l1 = strrchr(path, '\\');
  char *l2 = strrchr(path, '/');
  if (l2 > l1)
    l1 = l2;
  if (!l1)
    return NULL; // no dir name
  *l1 = 0;
  return path;
}

int strcasecmp(const char *s1, const char *s2) { return stricmp(s1, s2); }

int strncasecmp(const char *s1, const char *s2, size_t n) {
  return strnicmp(s1, s2, n);
}

#if _MSC_VER < 1900
namespace lldb_private {
int vsnprintf(char *buffer, size_t count, const char *format, va_list argptr) {
  int old_errno = errno;
  int r = ::vsnprintf(buffer, count, format, argptr);
  int new_errno = errno;
  buffer[count - 1] = '\0';
  if (r == -1 || r == count) {
    FILE *nul = fopen("nul", "w");
    int bytes_written = ::vfprintf(nul, format, argptr);
    fclose(nul);
    if (bytes_written < count)
      errno = new_errno;
    else {
      errno = old_errno;
      r = bytes_written;
    }
  }
  return r;
}
} // namespace lldb_private
#endif

#endif // _MSC_VER
