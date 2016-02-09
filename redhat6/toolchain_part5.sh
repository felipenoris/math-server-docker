#!/bin/sh

# Ninja build system https://ninja-build.org/ (used to build llvm)
# https://github.com/ninja-build/ninja/releases
cd ~/tmp
wget https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-linux.zip
unzip ninja-linux.zip
mv ninja /usr/bin

# compile ninja from source
#git clone git://github.com/ninja-build/ninja.git && cd ninja
#git checkout release
#./configure.py --bootstrap
#cp ninja /usr/bin
#chmod o+r /usr/bin/ninja # https://cmake.org/Bug/view.php?id=13910

# Based on: http://llvm.org/docs/GettingStarted.html#getting-started-quickly-a-summary
cd ~/tmp
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm # checkout llvm svn
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang # checkout clang svn
cd ../projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt # Checkout Compiler-RT (required to build the sanitizers)
svn co http://llvm.org/svn/llvm-project/openmp/trunk openmp # Checkout Libomp (required for OpenMP support)
#svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx # Checkout libcxx [Optional]
#svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi # Checkout libcxxabi [Optional]
#svn co http://llvm.org/svn/llvm-project/test-suite/trunk test-suite # Get the Test Suite Source Code [Optional]
cd ~/tmp
mkdir llvm_build
cd llvm_build
#cmake -G Ninja ../llvm
cmake ../llvm
