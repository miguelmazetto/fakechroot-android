/* Copyright (C) 1992,1996-1999,2003,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *        X/Open Portability Guide 4.2: ftw.h
 */

#ifndef _FTW2_H
#define	_FTW2_H	1

#include <features.h>

#include <sys/types.h>
#include <sys/stat.h>

#include <ftw.h>

__BEGIN_DECLS

/* Flags for fourth argument of `nftw'.  */
#define FTW_ACTIONRETVAL 16

/* Return values from callback functions.  */
#define FTW_CONTINUE 0
#define FTW_STOP 1
#define FTW_SKIP_SUBTREE 2
#define FTW_SKIP_SIBLINGS 3


/* Convenient types for callback functions.  */
typedef int (*__ftw_func_t) (__const char *__filename,
                             __const struct stat *__status, int __flag);
typedef int (*__nftw_func_t) (__const char *__filename,
                              __const struct stat *__status, int __flag,
                              struct FTW *__info);
#ifdef __FTW64_C
typedef int (*__ftw64_func_t) (__const char *__filename,
                               __const struct stat64 *__status, int __flag);
typedef int (*__nftw64_func_t) (__const char *__filename,
                                __const struct stat64 *__status,
                                int __flag, struct FTW *__info);
#endif

__END_DECLS

#endif //_FTW2_H