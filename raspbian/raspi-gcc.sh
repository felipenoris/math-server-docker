#!/bin/sh

# fix gcc build
cd /usr/include
sudo ln -s arm-linux-gnueabihf/sys sys
sudo ln -s arm-linux-gnueabihf/bits bits
sudo ln -s arm-linux-gnueabihf/gnu gnu

#https://gcc.gnu.org/bugzilla/show_bug.cgi?id=62099
#$ ../gcc-4.9.1/configure --enable-languages=c,c++ --prefix=/usr -with-float=hard

sudo apt-get -y install texinfo # to avoid libjava compilation error

# new gcc (cont.)
cd ~/tmp
# svn ls svn://gcc.gnu.org/svn/gcc/tags # listar releases
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_5_3_0_release/
cd gcc_5_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_build
cd gcc_build
../gcc_5_3_0_release/configure --prefix=/usr -with-float=hard #default is /usr/local, see https://gcc.gnu.org/install/configure.html
make -j 4 # incluir número de cores para compilação em paralelo, ver resultado de nproc
make install
hash -r # forget about old gcc

# Add new libraries to linker
echo "/usr/lib64" > usrLocalLib64.conf
mv usrLocalLib64.conf /etc/ld.so.conf.d/
ldconfig

# Checks if we got new gcc
gcc --version
g++ --version
gfortran --version
which gcc
