#!/bin/sh
# https://jakevdp.github.io/blog/2013/05/19/a-javascript-viewer-for-matplotlib-animations/

git clone https://github.com/jakevdp/JSAnimation.git
cd JSAnimation
python2 setup.py install
python3 setup.py install
cd ..
rm -rf JSAnimation
