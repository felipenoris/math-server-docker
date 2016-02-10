#!/bin/sh

# Jupyter
pip install IPython notebook
pip3 install IPython jupyterhub notebook
npm install -g configurable-http-proxy # depends on nodejs
# to start the server: jupyterhub

# jupyter and python libs
pip install numpy pandas # missing: sqlite, openblas, libxml2
pip3 install numpy pandas
#conda --version
#conda install jupyter
#conda install sqlite pandas openblas libxml2 numba numpy
# next step: configurar servidor jupyter para acesso remoto
# http://jupyter-notebook.readthedocs.org/en/latest/public_server.html

# Suporte Jupyter para outras linguagens
# https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

# Julia
# https://github.com/JuliaLang/IJulia.jl

# R
# http://irkernel.github.io/installation/
sudo yum -y install czmq-devel
R -e 'install.packages(c("rzmq","repr","IRkernel", "IRdisplay"), repos = c("http://irkernel.github.io/", "http://cran.fiocruz.br/", getOption("repos")), type = "source")'

# multi-user jupyter
# https://github.com/jupyter/jupyterhub
