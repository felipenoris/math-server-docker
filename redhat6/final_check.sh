#!/bin/sh

echo "Checking R..."
R --version

# Checks if we got new gcc
echo "Checking gcc..."
gcc --version
g++ --version
gfortran --version
which gcc

echo "Checking binutils..."
ld --version # check if install is ok
ld.gold --version

echo "Checking git..."
git --version

echo "Checking cmake..."
cmake --version

echo "Checking python2.7..."
which python
python --version
which pip
pip --version

echo "Checking python3..."
which python3
python3 --version
which pip3
pip3 --version

# Check llvm and clang version
echo "Checking llvm..."
/usr/local/bin/lli --version
/usr/local/bin/clang --version

echo "Checking julia..."
which julia
julia --version

echo "Checking nodejs..."
node --version
npm --version
