#!/bin/sh

### JULIA
cd ~/tmp
git clone https://github.com/JuliaLang/julia.git
cp -rf julia julia-dev
cd julia
git checkout release-0.4
echo "USECLANG=1" > Make.user
#echo "SANITIZE=1" >> Make.user
echo "USE_SYSTEM_LLVM=1" >> Make.user
echo "USE_LLVM_SHLIB=1" >> Make.user
echo "prefix=/usr/local/julia" >> Make.user
p="$(nproc --all)"
make -j $p
make install
#cd .. && rm -rf julia
ln -s /usr/local/julia/bin/julia /usr/local/bin/julia

# Set julia package dir
mkdir /usr/local/share/julia
echo "export JULIA_PKGDIR=/usr/local/share/julia" > /etc/profile.d/julia-pkg.sh
source /etc/profile
julia -e 'Pkg.init()'
mkdir $JULIA_PKGDIR/lib
chmod a+w $JULIA_PKGDIR/lib

# build dev version
cd ~/tmp/julia-dev
echo "USECLANG=1" > Make.user
#echo "SANITIZE=1" >> Make.user
echo "USE_SYSTEM_LLVM=1" >> Make.user
echo "USE_LLVM_SHLIB=1" >> Make.user
echo "prefix=/usr/local/julia-dev" >> Make.user
p="$(nproc --all)"
make -j $p
make install
