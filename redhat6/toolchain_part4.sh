#!/bin/sh

yum -y install sqlite sqlite-devel # needed by jupyterhub, used when compiling Python3

# Python 2.7 and 3 from source
# https://github.com/h2oai/h2o-2/wiki/Installing-python-2.7-on-centos-6.3.-Follow-this-sequence-exactly-for-centos-machine-only

cd ~/tmp
wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
wget https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tar.xz

tar xvf Python-2.7.11.tar.xz
tar xvf Python-3.5.1.tar.xz

cd Python-2.7.11
./configure --prefix=/usr/local
p="$(nproc --all)"
make -j $p && make altinstall # It is important to use altinstall instead of install, otherwise you will end up with two different versions of Python in the filesystem both named python.
ln -s /usr/local/bin/python2.7 /usr/local/bin/python # this will override system's python if /usr/local/bin appears before /usr/bin on env variable PATH
cd ..
rm -f Python-2.7.11.tar.xz && rm -rf Python-2.7.11

# Install pip for 2.7
cd ~/tmp
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
/usr/local/bin/python2.7 ez_setup.py
/usr/local/bin/easy_install-2.7 pip

echo "Checking python2.7..." >> ~/log.txt
python --version >> ~/log.txt
which python >> ~/log.txt
which pip >> ~/log.txt

cd Python-3.5.1
./configure --prefix=/usr/local
p="$(nproc --all)"
make -j $p && make altinstall
ln -s /usr/local/bin/python3.5 /usr/local/bin/python3
ln -s /usr/local/bin/pip3.5 /usr/local/bin/pip3
cd ..
rm -f Python-3.5.1.tar.xz && rm -rf Python-3.5.1
echo "Checking python3..." >> ~/log.txt
/usr/local/bin/python3 --version >> ~/log.txt
which pip3 >> ~/log.txt
