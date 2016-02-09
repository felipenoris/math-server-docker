#!/bin/sh

### JULIA
cd ~/tmp
git clone https://github.com/JuliaLang/julia.git
cp -rf julia julia-dev
cd julia
git checkout release-0.4
echo "USECLANG=1" > Make.user
echo "prefix=/usr/local/julia" >> Make.user
make -j 4
make install
#cd .. && rm -rf julia
ln -s /usr/local/julia/bin/julia /usr/local/bin/julia
echo "# Check julia" >> log.txt
which julia >> log.txt
julia --version >> log.txt

# build dev version
cd ~/tmp/julia-dev
echo "USECLANG=1" > Make.user
#echo "SANITIZE=1" >> Make.user
echo "USE_SYSTEM_LLVM=1" >> Make.user
echo "USE_LLVM_SHLIB=1" >> Make.user
echo "prefix=/usr/local/julia-dev" >> Make.user
make -j 4
make install
