#!/bin/sh

# nodejs
cd ~/tmp
wget https://github.com/nodejs/node/archive/v5.5.0.tar.gz
tar -xvf v5.5.0.tar.gz
cd node-5.5.0
./configure
make -j 4
make install

echo "# Check nodejs install"
node --version >> log.txt
