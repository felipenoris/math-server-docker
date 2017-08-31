#!/bin/sh

/usr/local/conda/anaconda3/envs/py2/bin/pip install \
	pypandoc

pip2 install distribute

pip2 install \
	astroid \
	atom \
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
	feather \
	jsonschema \
	ldap3 \
	names \
	pytest-cov \
	pytest-html \
	pymc \
	pymemcache \
	pymongo \
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

pip2 install \
	Cython \
	matplotlib \
	nose \
	scipy

pip2 install \
	arch \
	pandas \
	statistics \
	h5py

pip2 install \
	tables \
	tox \
	mpld3

# setting version restrictions to use llvm 3.7.1
pip2 install 'llvmlite<0.13.0'
pip2 install 'numba<0.28.0'
