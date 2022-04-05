#!/bin/bash

SDIR=$PWD

export NDK_TOOLCHAIN=/home/mmz/dev/ndk
export TOOLCHAIN=$NDK_TOOLCHAIN/toolchains/llvm/prebuilt/linux-x86_64
export ANDROID_USR=$TOOLCHAIN/sysroot/usr
export API=24 # Set this to your minSdkVersion.

rm -rf $SDIR/jniLibs
mkdir $SDIR/jniLibs

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
	export JNIOUTDIR=$SDIR/jniLibs/$JNIOUT
	mkdir $JNIOUTDIR
}

IS32BIT=0

greencol=$(tput setaf 46)
defaultcol=$(tput sgr0)

configure_fakeroot(){
	export SHELL="/system/bin/sh"
	FDIR=$SDIR/fakeroot

	rm -rf $FDIR/build
	cd $FDIR
	$FDIR/bootstrap

	echo "#define _ID_T
#define SEND_GET_XATTR(a,b,c) send_get_xattr(a,b)
#define SEND_GET_XATTR64(a,b,c) send_get_xattr64(a,b)" >> $FDIR/config.h.in

	mkdir $FDIR/build
	cd $FDIR/build
	$FDIR/configure --host $TARGET --with-ipc=tcp

	#if [[ $IS32BIT -gt 0 ]]
	#then
	#	sed -i '/#define WRAP_LSTAT64 lstat64/d' $FDIR/build/config.h
	#	sed -i '/#define WRAP_STAT64 stat64/d' $FDIR/build/config.h
	#	sed -i '/#define WRAP_FSTAT64 fstat64/d' $FDIR/build/config.h
	#	sed -i '/#define WRAP_FSTATAT64 fstatat64/d' $FDIR/build/config.h
	#fi
}

configure_chroot(){
	cd $SDIR
	$SDIR/autogen.sh

	rm -rf $SDIR/build
	mkdir $SDIR/build
	cd $SDIR/build
	$SDIR/configure --host $TARGET _LIBC=1

	echo "#define __BIONIC_LP32_USE_STAT64" >> $SDIR/config.h.in
}

# Parallel configure :D
configure_all(){
	printf "\n${greencol}Configuring all projects for $TARGET...\n\n${defaultcol}"
	configure_android
	yellow=$(tput setaf 185)
	purple=$(tput setaf 147)
	configure_chroot 2>&1 | sed "s/.*/$yellow&$defaultcol/" &
	configure_fakeroot 2>&1 | sed "s/.*/$purple&$defaultcol/" &
	wait
}

compile_chroot(){
	printf "\n${greencol}Compiling FakeChroot for $TARGET...\n\n${defaultcol}"
	cd $SDIR/build
	make -j

	printf "\n${greencol}Compiling getopt for $TARGET...\n\n${defaultcol}"
	
	$CC $SDIR/src/getopt.c -DTEST -o $SDIR/build/getopt

	cp $SDIR/build/getopt $JNIOUTDIR/libgetopt.so
	cp $SDIR/build/src/.libs/libfakechroot.so $JNIOUTDIR/libfakechroot.so
}

compile_fakeroot(){
	printf "\n${greencol}Compiling Fakeroot for $TARGET...\n\n${defaultcol}"

	cd $SDIR/fakeroot/build

	make -j

	cp faked $JNIOUTDIR/libfaked.so
	cp .libs/libfakeroot-0.so $JNIOUTDIR/libfakeroot.so
}

doall(){
	configure_all
	compile_fakeroot
	compile_chroot
}

export TARGET=aarch64-linux-android
JNIOUT=arm64-v8a
doall

export TARGET=x86_64-linux-android
JNIOUT=x86_64
doall

IS32BIT=1
export TARGET=armv7a-linux-androideabi
JNIOUT=armeabi-v7a
doall

printf "\nDone!\n\n"

cd $SDIR