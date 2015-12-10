#!/bin/sh

sudo yum update
sudo yum install wget
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh epel-release-7-5.noarch.rpm
sudo yum update

# instala comando /bin/sh/patch, precisa para a compilação do julia
sudo yum install patch

# instala compilador C++ para compilação do julia
sudo yum install gcc-c++
sudo yum install gcc-gfortran
sudo yum install bzip2
sudo yum install cmake

sudo yum install git

# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
sudo yum install gcc perl-ExtUtils-MakeMaker
sudo yum remove git
cd /usr/src
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
sudo tar xzf git-2.6.4.tar.gz
cd git-2.6.4
sudo make prefix=/usr/local/git all
sudo make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc

adicionar linha no /etc/bashrc: export PATH=$PATH:/usr/local/git/bin
source /etc/bashrc

sudo rm /usr/src/git-2.6.4.tar.gz
cd
git clone https://github.com/JuliaLang/julia.git
cd julia
make

# para o R

cd
mkdir tmp
cd tmp
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/lapack-devel-3.4.2-4.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/blas-devel-3.4.2-4.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libicu-devel-50.1.2-11.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/texinfo-tex-5.1-4.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/texlive-epsf-svn21461.2.7.4-32.el7.noarch.rpm
sudo yum localinstall blas-devel-3.4.2-4.el7.x86_64.rpm
sudo yum localinstall lapack-devel-3.4.2-4.el7.x86_64.rpm
sudo yum remove libicu
sudo yum localinstall libicu-devel-50.1.2-11.el7.x86_64.rpm
sudo yum localinstall texlive-epsf-svn21461.2.7.4-32.el7.noarch.rpm
sudo yum localinstall texinfo-tex-5.1-4.el7.x86_64.rpm
sudo yum install R