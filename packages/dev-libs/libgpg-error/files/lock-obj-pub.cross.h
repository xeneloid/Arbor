## thanks to Void Linux for this hack https://github.com/voidlinux/void-packages/blob/4268d19692534743dd332d2bcb1b02d9550ed189/srcpkgs/libgpg-error/files/lock-obj-pub.arm.h

## lock-obj-pub.x86_64-unknown-linux-gnu.h
## File created by gen-posix-lock-obj - DO NOT EDIT
## To be included by mkheader into gpg-error.h

typedef struct
{
  long _vers;
  union {
    volatile char _priv[24];
    long _x_align;
    long *_xp_align;
  } u;
} gpgrt_lock_t;

#define GPGRT_LOCK_INITIALIZER {1,{{0,0,0,0,0,0,0,0, \
                                    0,0,0,0,0,0,0,0, \
                                    0,0,0,0,0,0,0,0, \
                                    0,0,0,0,0,0,0,0, \
                                    0,0,0,0,0,0,0,0}}}
##
## Local Variables:
## mode: c
## buffer-read-only: t
## End:
##
