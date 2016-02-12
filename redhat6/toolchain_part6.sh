#!/bin/sh

cd ~/tmp/llvm_build
p="$(nproc --all)"
make -j $p
make install
ln -s /usr/local/lib/libLLVM.so /usr/local/lib/libLLVM-3.7.1.so

cd ..
rm -rf llvm_build
rm -rf llvm
