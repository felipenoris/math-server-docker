#!/bin/sh

apt-get update

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
