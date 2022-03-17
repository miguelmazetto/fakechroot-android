#!/bin/bash

export NDK_TOOLCHAIN=/home/mmz/dev/ndk
#export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
export TOOLCHAIN=$NDK_TOOLCHAIN/toolchains/llvm/prebuilt/linux-x86_64
# Only choose one of these, depending on your device...
export ANDROID_USR=$TOOLCHAIN/sysroot/usr

export TARGET=aarch64-linux-android
#export TARGET=armv7a-linux-androideabi
#export TARGET=i686-linux-android
#export TARGET=x86_64-linux-android

export CFLAGS="-I$ANDROID_USR/include -fPIE"
export LDFLAGS="-R$ANDROID_USR/lib/aarch64-linux-android/24 -L$ANDROID_USR/lib/aarch64-linux-android/24"

# Set this to your minSdkVersion.
export API=24
export ARCH=arm64
# Configure and build.
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

export __ANDROID__=1

export SHELL="/system/bin/sh"

./bootstrap
mkdir build
cd build

../configure --host aarch64-linux-android --with-ipc=tcp
echo "#define _ID_T
#define SEND_GET_XATTR(a,b,c) send_get_xattr(a,b)
#define SEND_GET_XATTR64(a,b,c) send_get_xattr64(a,b)" >> ../config.h.in

make -j7

cd ..