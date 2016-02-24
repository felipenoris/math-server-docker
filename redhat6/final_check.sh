
echo "system path is ${PATH}"

echo "system libs..."
ldconfig -p

echo "Checking R..."
R --version

echo "Checking Java..."
java -version
javac -version

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

# Swig
which ccache-swig
ccache-swig -V

# Check llvm and clang version
echo "Checking llvm..."
/usr/local/bin/lli --version
/usr/local/bin/clang --version

echo "Checking julia..."
which julia
julia --version
julia -e 'println("LOAD_PATH = ", LOAD_PATH)'
julia -e 'println("Pkg.dir = ", Pkg.dir())'
ls -la /usr/local/julia/share/julia/site

echo "Checking nodejs..."
node --version
npm --version

echo "Checking jupyterhub..."
jupyterhub --version
