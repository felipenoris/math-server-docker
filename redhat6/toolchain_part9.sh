#!/bin/sh

# nodejs
cd ~/tmp
wget https://github.com/nodejs/node/archive/v5.5.0.tar.gz
tar -xvf v5.5.0.tar.gz
cd node-5.5.0
./configure
p="$(nproc --all)"
make -j $p
make install
cd ..
rm -f v5.5.0.tar.gz && rm -rf node-5.5.0
echo "Checking nodejs..."
node --version >> ~/log.txt
npm --version >> ~/log.txt
