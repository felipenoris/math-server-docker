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
python --version
which python
which pip

echo "Checking python3..."
/usr/local/bin/python3 --version
which pip3

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
