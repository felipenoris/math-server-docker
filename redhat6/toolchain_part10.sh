#!/bin/sh

# Jupyter
# Add python2.7 kernel: https://github.com/jupyter/jupyter/issues/71
pip3 install IPython jupyterhub notebook ipykernel
python3 -m ipykernel install # register Python 3 kernel (not technically necessary at this point, but a good idea)
pip install IPython notebook ipykernel
python -m ipykernel install # register Python 2 kernel
npm install -g configurable-http-proxy # depends on nodejs

# to start the server: jupyterhub
# or: jupyterhub --ip=192.168.1.2 --port=443
# you may have to open port for external access:
# 	/sbin/iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
# 	/sbin/service iptables save

# jupyter and python libs
pip install numpy pandas # missing: sqlite, openblas, libxml2
pip3 install numpy pandas

# Support for other languages
# https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

# Add Julia kernel
# https://github.com/JuliaLang/IJulia.jl
julia -e 'Pkg.add("IJulia")'
# https://github.com/JuliaLang/IJulia.jl/issues/341
julia -e 'using IJulia' #precompilation
cp -r ˜/.local/share/jupyter/kernels/julia-0.4 /usr/local/share/jupyter/kernels # registers global kernel

# R
# http://irkernel.github.io/installation/
yum -y install czmq-devel
R -e 'install.packages(c("rzmq","repr","IRkernel","IRdisplay"), repos = c("http://irkernel.github.io/", getOption("repos")),type = "source")'
R -e 'IRkernel::installspec(user = FALSE)' # makes R kernel available for jupyter
