#!/bin/bash

SDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

export TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
export ANDROID_USR=$TOOLCHAIN/sysroot/usr
export API=24 # Set this to your minSdkVersion.

RDIR=SDIR
if [[ ! -z "$MMZ_ROOTFOLDER" ]]; then RDIR=$MMZ_ROOTFOLDER fi

configure_android(){
	export CFLAGS="-I$ANDROID_USR/include" # -fPIE
	export LDFLAGS="-R$ANDROID_USR/lib/$TARGET/$API -L$ANDROID_USR/lib/$TARGET/$API"
	export AR=$TOOLCHAIN/bin/llvm-ar
	export CC=$TOOLCHAIN/bin/$TARGET$API-clang
	export AS=$CC
	export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
	export LD=$TOOLCHAIN/bin/ld
	export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
	export STRIP=$TOOLCHAIN/bin/llvm-strip
	JNIOUTDIR=$RDIR/jniLibs/$ARCH2
	mkdir -p $JNIOUTDIR
}

greencol=$(tput setaf 46)
defaultcol=$(tput sgr0)

configure_fakechroot(){
	printf "\n${greencol}Configuring fakechroot for $TARGET...\n\n${defaultcol}"
	cd $SDIR; rm -rf build;	mkdir build; cd build

	../configure --host $TARGET _LIBC=1
	echo "#define __BIONIC_LP32_USE_STAT64
#define NEW_GLIBC 1" >> $SDIR/config.h.in
}

compile_fakechroot(){
	printf "\n${greencol}Compiling fakechroot for $TARGET...\n\n${defaultcol}"
	make -j
	cp $SDIR/build/src/.libs/libfakechroot.so $JNIOUTDIR/libfakechroot.so
}

doall(){
	configure_android
	configure_fakechroot
	compile_fakechroot
}

cd $SDIR; ./autogen.sh

export TARGET=aarch64-linux-android
JNIOUT=arm64-v8a
doall

export TARGET=x86_64-linux-android
JNIOUT=x86_64
doall

export TARGET=armv7a-linux-androideabi
JNIOUT=armeabi-v7a
doall