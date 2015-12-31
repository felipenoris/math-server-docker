#!/bin/sh

cd ~/tmp/llvm_build
cmake --build .
cmake --build . # in case it fails...
cmake --build . # in case it fails...
cmake --build . --target install
#cmake -DCMAKE_INSTALL_PREFIX=/tmp/llvm -P cmake_install.cmake # para escolher o diretorio
#cd ..
#rm -rf llvm_build
#rm -rf llvm

# clang
# http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
#wget http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
#tar xf cfe-3.7.0.src.tar.xz
#cd cfe-3.7.0.src
