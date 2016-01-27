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
