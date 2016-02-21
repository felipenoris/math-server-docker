#!/bin/sh

cd ~/tmp/llvm_build
make ENABLE_OPTIMIZED=1 DISABLE_ASSERTIONS=1 CXXFLAGS="-I/usr/local/include/python2.7 -L/usr/local/lib -lpython2.7" -j "$(nproc --all)"
make install
ln -s /usr/local/lib/libLLVM.so /usr/local/lib/libLLVM-3.7.1.so
ldconfig

cd ..
rm -rf llvm_build
rm -rf llvm
