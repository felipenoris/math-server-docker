#!/bin/sh

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade

# Debian R
# https://cran.r-project.org/bin/linux/debian/
# apt-cache search "^r-.*" | sort
apt-get -y install libopenblas-base

# suggested packages for R
apt-get -y install devscripts liblzma-doc ncurses-doc readline-doc ess r-doc-info r-doc-pdf r-mathlib debhelper texlive-base texlive-latex-base
  texlive-generic-recommended texlive-fonts-recommended texlive-fonts-extra texlive-extra-utils texlive-latex-recommended
  texlive-latex-extra texinfo

# R base and rtools
apt-get -y install r-base r-base-dev

# More tools...
apt-get -y install subversion flex


# Julia
#For Raspberry Pi 2, which is ARMv7, the default build should work. However, the CPU type is also not detected by LLVM. Fix this by adding JULIA_CPU_TARGET=cortex-a7 to Make.user.

#Depending on the exact compiler and distribution, there might be a build failure due to unsupported inline assembly. In that case, add MARCH=armv7-a to Make.user.


#If building LLVM fails, you can download binaries from the LLVM website:

#Download the LLVM 3.7.0 binaries for ARMv7a and extract them in a local directory.
# http://llvm.org/releases/3.7.0/clang+llvm-3.7.0-armv7a-linux-gnueabihf.tar.xz
#Add the following to Make.user (adjusting the path to the llvm-config binary):

#override USE_SYSTEM_LLVM=1
#LLVM_CONFIG=${EXTRACTED_LOCATION}/bin/llvm-config

# download files make -C deps getall