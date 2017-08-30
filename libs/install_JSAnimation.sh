#!/bin/sh
# https://jakevdp.github.io/blog/2013/05/19/a-javascript-viewer-for-matplotlib-animations/

git clone https://github.com/jakevdp/JSAnimation.git
cd JSAnimation
/usr/local/conda/anaconda3/envs/py2/bin/python setup.py install
python3 setup.py install
cd ..
rm -rf JSAnimation
