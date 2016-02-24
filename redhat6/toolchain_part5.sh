
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

# LLVM 3.7.1
# http://llvm.org/docs/GettingStarted.html#getting-started-quickly-a-summary
# http://llvm.org/git/llvm.git

# LLVM
wget http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz

# Clang /tools/clang
wget http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz

# CompilerRT /projects/compiler-rt
wget http://llvm.org/releases/3.7.1/compiler-rt-3.7.1.src.tar.xz

# libc++ /projects/libcxx
wget http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz

# libc++abi /projects/libcxxabi
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

rm -f *tar.xz

mkdir llvm_build
cd llvm_build

# http://llvm.org/docs/CMake.html
# find / -iname 'ffi.h'
# cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_PIC=ON -DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/usr/lib64/libffi-3.0.5/include  ../llvm
../llvm/configure --enable-shared
