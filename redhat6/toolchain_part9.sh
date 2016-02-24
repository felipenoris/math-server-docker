
# nodejs
cd ~/tmp
wget https://github.com/nodejs/node/archive/v5.6.0.tar.gz
tar xf v5.6.0.tar.gz
cd node-5.6.0
./configure
make -j "$(nproc --all)"
make install
cd ..
rm -f v5.6.0.tar.gz && rm -rf node-5.6.0
