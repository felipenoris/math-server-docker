#!/bin/sh

# Based on: http://llvm.org/docs/GettingStarted.html#getting-started-quickly-a-summary
cd ~/tmp
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_371/final llvm
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_371/final clang # checkout clang svn
cd ../projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_371/final compiler-rt # Checkout Compiler-RT (required to build the sanitizers)
svn co http://llvm.org/svn/llvm-project/openmp/tags/RELEASE_371/final openmp # Checkout Libomp (required for OpenMP support)

cd ~/tmp
mkdir llvm_build
cd llvm_build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON ../llvm
