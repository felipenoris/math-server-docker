#!/bin/sh

# cleans gcc installation files
cd ~/tmp
rm -rf gcc_build && rm -rf gcc_5_3_0_release

# new binutils
# CentOS6 vem com versão antiga do binutils.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.gnu.org/software/binutils/
yum -y install bison # byacc # needed to build ld.gold, which is needed by nodejs
cd ~/tmp
wget http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.gz
tar -xvzf binutils-2.26.tar.gz
cd binutils-2.26
./configure
make -j 4
make install
cd ..
rm -rf binutils-2.26
rm -f binutils-2.26.tar.gz

echo "# Check binutils installation" >> log.txt
ld --version >> log.txt # check if install is ok

### GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
cd ~/tmp
wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
tar xzf git-2.6.4.tar.gz
cd git-2.6.4
make -j 4 prefix=/usr/local all
make prefix=/usr/local install
#cd ..
#rm -f git-2.6.4.tar.gz && rm -rf git-2.6.4

echo "#Check git installation" >> log.txt
git --version >> log.txt

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
cd ~/tmp
wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz
tar -xvzf cmake-3.4.1.tar.gz
cd cmake-3.4.1
./bootstrap && make -j 4 && make install

echo "# Check cmake installation" >> log.txt
cmake --version >> log.txt
