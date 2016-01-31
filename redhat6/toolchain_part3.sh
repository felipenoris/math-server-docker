#!/bin/sh

# cleans gcc installation files
cd ~/tmp
rm -rf gcc_build && rm -rf gcc_5_3_0_release

# new binutils
# CentOS6 vem com versão antiga do binutils.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.gnu.org/software/binutils/
cd ~/tmp
wget http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz
tar -xvzf binutils-2.25.tar.gz
cd binutils-2.25
# conferir comandos abaixo
./configure
make
make install
cd ..
rm -rf binutils-2.25
rm -f binutils-2.25.tar.gz

### GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
cd ~/tmp
wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
tar xzf git-2.6.4.tar.gz
cd git-2.6.4
make prefix=/usr/local all
make prefix=/usr/local install
#cd ..
#rm -f git-2.6.4.tar.gz && rm -rf git-2.6.4
git --version
###

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
cd ~/tmp
wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz
tar -xvzf cmake-3.4.1.tar.gz
cd cmake-3.4.1
./bootstrap && make && make install
# needs to logout and login (fixme)

# llvm needs python 2.7 or higher
# Python e Jupyter
# https://www.continuum.io/downloads
# http://jupyter.readthedocs.org/en/latest/install.html
# https://jupyter.org/
# http://conda.pydata.org/docs/test-drive.html#managing-conda
# Scipy http://www.scipy.org/install.html
cd ~/tmp
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.4.1-Linux-x86_64.sh
