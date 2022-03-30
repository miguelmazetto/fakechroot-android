#ifndef _FTW2_H
#define	_FTW2_H	1

#ifdef _LIBC
# include <include/sys/stat.h>
#else
# include <sys/stat.h>
#endif

#include <ftw.h>

__BEGIN_DECLS

/* Flags for fourth argument of `nftw'.  */
enum
{
  FTW_ACTIONRETVAL = 16        /* Assume callback to return FTW_* values instead of
                           zero to continue and non-zero to terminate.  */
#  define FTW_ACTIONRETVAL FTW_ACTIONRETVAL
};

/* Return values from callback functions.  */
enum
{
  FTW_CONTINUE = 0,        /* Continue with next sibling or for FTW_D with the
                           first child.  */
# define FTW_CONTINUE        FTW_CONTINUE
  FTW_STOP = 1,                /* Return from `ftw' or `nftw' with FTW_STOP as return
                           value.  */
# define FTW_STOP        FTW_STOP
  FTW_SKIP_SUBTREE = 2,        /* Only meaningful for FTW_D: Don't walk through the
                           subtree, instead just continue with its next
                           sibling. */
# define FTW_SKIP_SUBTREE FTW_SKIP_SUBTREE
  FTW_SKIP_SIBLINGS = 3,/* Continue with FTW_DP callback for current directory
                            (if FTW_DEPTH) and then its siblings.  */
# define FTW_SKIP_SIBLINGS FTW_SKIP_SIBLINGS
};

/* Convenient types for callback functions.  */
typedef int (*__ftw_func_t) (__const char *__filename,
                             __const struct stat *__status, int __flag);
#ifdef __USE_LARGEFILE64
typedef int (*__ftw64_func_t) (__const char *__filename,
                               __const struct stat64 *__status, int __flag);
#endif
typedef int (*__nftw_func_t) (__const char *__filename,
                              __const struct stat *__status, int __flag,
                              struct FTW *__info);
# ifdef __USE_LARGEFILE64
typedef int (*__nftw64_func_t) (__const char *__filename,
                                __const struct stat64 *__status,
                                int __flag, struct FTW *__info);
# endif

__END_DECLS

#endif //_FTW2_H