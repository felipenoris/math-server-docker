#!/bin/sh

# new gcc (cont.)
cd ~/tmp
# svn ls svn://gcc.gnu.org/svn/gcc/tags # listar releases
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_5_3_0_release/
cd gcc_5_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_build
cd gcc_build
../gcc_5_3_0_release/configure --prefix=/usr/local # default is /usr/local, see https://gcc.gnu.org/install/configure.html
p="$(nproc --all)"
make -j $p
make install
hash -r # forget about old gcc

# Add new libraries to linker
echo "/usr/local/lib64" > usrLocalLib64.conf
mv usrLocalLib64.conf /etc/ld.so.conf.d/
ldconfig
