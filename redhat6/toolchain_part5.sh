#!/bin/sh

# Based on: http://llvm.org/docs/GettingStarted.html#getting-started-quickly-a-summary
#cd ~/tmp
#svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_371/final llvm
#cd llvm/tools
#svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_371/final clang # checkout clang svn
#cd ../projects
#svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_371/final compiler-rt # Checkout Compiler-RT (required to build the sanitizers)
#svn co http://llvm.org/svn/llvm-project/openmp/tags/RELEASE_371/final openmp # Checkout Libomp (required for OpenMP support)

#cd ~/tmp
#mkdir llvm_build
#cd llvm_build
#cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON ../llvm




###################

## LLVM ##

#LLVM_VER=3.7

#LLVM_GIT_URL_BASE=http://llvm.org/git
#LLVM_GIT_URL_LLVM=$(LLVM_GIT_URL_BASE)/llvm.git
#LLVM_GIT_URL_CLANG=$(LLVM_GIT_URL_BASE)/clang.git
#LLVM_GIT_URL_COMPILER_RT=$(LLVM_GIT_URL_BASE)/compiler-rt.git
#LLVM_GIT_URL_LLDB=$(LLVM_GIT_URL_BASE)/lldb.git
#LLVM_GIT_URL_LIBCXX=$(LLVM_GIT_URL_BASE)/libcxx.git
#LLVM_GIT_URL_LIBCXXABI=$(LLVM_GIT_URL_BASE)/libcxxabi.git

#LLVM_BUILDTYPE=Release

#http://llvm.org/git/llvm.git

# VER 3.7.1

# dependencies
yum -y install libedit-devel libffi-devel #swig libedit-devel
# Centof7 http://rpm.pbone.net/index.php3/stat/4/idpl/31980484/dir/centos_7/com/libedit-devel-3.0-12.20121213cvs.el7.x86_64.rpm.html
# wget ftp://ftp.muug.mb.ca/mirror/centos/7.2.1511/os/x86_64/Packages/libedit-devel-3.0-12.20121213cvs.el7.x86_64.rpm
# Rh6 http://rpm.pbone.net/index.php3/stat/4/idpl/16860051/dir/redhat_el_6/com/libedit-devel-3.0-1.20090722cvs.el6.x86_64.rpm.html
# wget ftp://ftp.pbone.net/mirror/atrpms.net/el6-x86_64/atrpms/testing/libedit-devel-3.0-1.20090722cvs.el6.x86_64.rpm

# swig 3.0.8
# https://github.com/swig/swig/archive/rel-3.0.8.tar.gz
# http://downloads.sourceforge.net/swig/swig-3.0.8.tar.gz
cd ~/tmp
wget http://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.8.tar.gz
echo "c96a1d5ecb13d38604d7e92148c73c97  swig-3.0.8.tar.gz" > SWIGMD5
RESULT=$(md5sum -c SWIGMD5)
echo ${RESULT} > ~/check-swig-md5.txt
tar xf swig-3.0.8.tar.gz
cd swig-3.0.8
./configure
make -j "$(nproc --all)"
make install
cd ..
rm -f swig-3.0.8.tar.gz SWIGMD5 && rm -rf swig-3.0.8

cd ~/tmp

# LLVM source code
wget http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz

# Clang source code /tools/clang
wget http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz

# CompilerRT source code /projects/compiler-rt
wget http://llvm.org/releases/3.7.1/compiler-rt-3.7.1.src.tar.xz

# libc++ source code /projects/libcxx
wget http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz

# libc++abi source code /projects/libcxxabi
wget http://llvm.org/releases/3.7.1/libcxxabi-3.7.1.src.tar.xz

# lldb /tools/lldb
wget http://llvm.org/releases/3.7.1/lldb-3.7.1.src.tar.xz

mkdir llvm
tar xf llvm-3.7.1.src.tar.xz -C llvm --strip-components=1

mkdir llvm/tools/clang
tar xf cfe-3.7.1.src.tar.xz -C llvm/tools/clang --strip-components=1

mkdir llvm/projects/compiler-rt
tar xf compiler-rt-3.7.1.src.tar.xz -C llvm/projects/compiler-rt --strip-components=1

mkdir llvm/projects/libcxx
tar xf libcxx-3.7.1.src.tar.xz -C llvm/projects/libcxx --strip-components=1

mkdir llvm/projects/libcxxabi
tar xf libcxxabi-3.7.1.src.tar.xz -C llvm/projects/libcxxabi --strip-components=1

mkdir llvm/tools/lldb
tar xf lldb-3.7.1.src.tar.xz -C llvm/tools/lldb --strip-components=1

mkdir llvm_build
cd llvm_build

# http://llvm.org/docs/CMake.html
# find / -iname 'ffi.h'
#cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_PIC=ON -DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/usr/lib64/libffi-3.0.5/include  ../llvm
../llvm/configure --enable-shared
