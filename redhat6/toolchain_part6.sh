#!/bin/sh

cd ~/tmp/llvm_build
p="$(nproc --all)"
make -j $p
make install

cd ..
rm -rf llvm_build
rm -rf llvm
