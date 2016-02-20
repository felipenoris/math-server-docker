#!/bin/sh

cd ~/tmp/llvm_build
make -j "$(nproc --all)"
make install
ln -s /usr/local/lib/libLLVM.so /usr/local/lib/libLLVM-3.7.1.so

cd ..
rm -rf llvm_build
rm -rf llvm
