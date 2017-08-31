#!/bin/sh

pip install \
	pypandoc

pip3 install distribute

pip3 install \
	astroid \
	attrs \
	bcolz \
	bcrypt \
	beautifulsoup4 \
	blist \
	bitarray \
	blaze \
	bokeh \
	bottleneck \
	BTrees \
	bz2file \
	characteristic \
	colander \
	coverage \
	cryptography \
	csvkit \
	cymem \
	cytoolz \
	dask \
	datetime \
	deap \
	docx \
	jsonschema \
	names \
	pymemcache \
	pymongo \
	pytest-cov \
	pytest-html \
	python-daemon \
	python-docx \
	pyyaml \
	requests \
	rstr \
	seaborn \
	schedule \
	scikit-learn \
	simplejson \
	sphinx \
	spyder \
	sqlalchemy \
	sympy \
	sqlparse \
	suds-jurko \
	xlsxwriter

pip3 install \
	Cython \
	matplotlib \
	nose \
	scipy

pip3 install \
	arch \
	pandas \
	statistics \
	h5py

pip3 install \
	tables \
	tox \
	mpld3

# setting version restrictions to use llvm 3.7.1
pip3 install 'llvmlite<0.13.0'
pip3 install 'numba<0.28.0'
