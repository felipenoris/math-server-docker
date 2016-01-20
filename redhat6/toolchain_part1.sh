#!/bin/sh

#dhclient eth0
#yum -y install system-config-network-tui

# default EC2 user is: ec2-user

# run this script with: sudo ./toolchain.sh

yum install -y wget
mkdir ~/tmp
cd ~/tmp
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain.sh
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
#rm -f epel-release-6-8.noarch.rpm
yum -y update

# para o R
cd ~/tmp
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/lapack-devel-3.2.1-4.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/blas-devel-3.2.1-4.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/libicu-devel-4.2.1-12.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/texinfo-tex-4.13a-8.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/glpk-4.40-1.1.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/glpk-devel-4.40-1.1.el6.x86_64.rpm'

yum -y localinstall blas-devel-3.2.1-4.el6.x86_64.rpm
yum -y localinstall lapack-devel-3.2.1-4.el6.x86_64.rpm
yum -y localinstall libicu-devel-4.2.1-12.el6.x86_64.rpm
yum -y localinstall texinfo-tex-4.13a-8.el6.x86_64.rpm
yum -y localinstall glpk-4.40-1.1.el6.x86_64.rpm
yum -y localinstall glpk-devel-4.40-1.1.el6.x86_64.rpm
#rm -f *.rpm
yum -y install unixodbc-devel QuantLib QuantLib-devel boost boost-devel libxml2 libxml2-devel
yum -y install R

export CPATH=/usr/include/glpk

# Ferramentas para compilação
yum -y install patch gcc-c++ gcc-gfortran bzip2 cmake curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker valgrind lynx unzip man

# Java http://openjdk.java.net/install/index.html
yum -y install java-1.8.0-openjdk-devel.x86_64 java-1.8.0-openjdk-javadoc.noarch

# new gcc
# CentOS6 vem com versão antiga do GCC.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.vultr.com/docs/how-to-install-gcc-on-centos-6
# https://gcc.gnu.org/install/build.html
yum -y install svn flex zip libgcc.i686 glibc-devel.i686 # texinfo-tex already installed
