#ifndef _FTW2_H
#define	_FTW2_H	1

#ifdef __USE_XOPEN_EXTENDED
typedef int (*__nftw_func_t) (const char *__filename,
			      const struct stat *__status, int __flag,
			      struct FTW *__info);
# ifdef __USE_LARGEFILE64
typedef int (*__nftw64_func_t) (const char *__filename,
				const struct stat64 *__status,
				int __flag, struct FTW *__info);
# endif
#endif

#endif //_FTW2_H