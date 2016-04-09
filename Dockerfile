
# docker build --no-cache -t math-server:latest .

# 8787 for RStudio
# 8000 for Jupyter

# docker run -d -p 8787:8787 -p 8000:8000 --name ms1 math-server

FROM centos:7

MAINTAINER felipenoris <felipenoris@users.noreply.github.com>

WORKDIR /root

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

RUN echo "export PATH=/usr/local/sbin:/usr/local/bin:${PATH}" > /etc/profile.d/local-bin.sh \
	&& echo "export CPATH=/usr/include/glpk" > /etc/profile.d/glpk-include.sh \
	&& source /etc/profile

RUN yum install -y wget

RUN wget http://mirror.globo.com/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
	rpm -ivh epel-release-7-5.noarch.rpm && \
	rm -f epel-release-7-5.noarch.rpm

RUN yum update -y && yum install -y \
	bison \
	bzip2 \
	cmake \
	curl-devel \
	expat-devel \
	flex \
	gcc \
	gcc-c++ \
	gcc-gfortran \
	gettext-devel \
	glibc-devel \
	java-1.8.0-openjdk-devel \
	lynx \
	libcurl \ 
	libcurl-devel \
	libedit-devel libffi-devel \
	libgcc \
	m4 \
	make \
	man \
	nano \
	nload \
	htop \
	openssl098e \
	openssl-devel \
	patch \
	perl-ExtUtils-MakeMaker \
	svn \
	unzip \
	valgrind \
	texinfo-tex \
	sqlite \
	sqlite-devel \
	vim \
	zlib-devel \
	zip

# GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.8.1.tar.xz \
	&& tar xf git-2.8.1.tar.xz && cd git-2.8.1 \
	&& make -j"$(nproc --all)" prefix=/usr/local all \
	&& make prefix=/usr/local -j"$(nproc --all)" install \
	&& cd .. && rm -f git-2.8.1.tar.xz && rm -rf git-2.8.1

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
RUN wget https://cmake.org/files/v3.5/cmake-3.5.1.tar.gz \
	&& tar xf cmake-3.5.1.tar.gz && cd cmake-3.5.1 \
	&& ./bootstrap && make -j"$(nproc --all)" && make -j"$(nproc --all)" install \
	&& cd .. && rm -rf cmake-3.5.1 && rm -f cmake-3.5.1.tar.gz \
	&& echo "export CMAKE_ROOT=/usr/local/share/cmake-3.5" > /etc/profile.d/cmake-root.sh \
	&& source /etc/profile

# Python 2.7
# https://github.com/h2oai/h2o-2/wiki/Installing-python-2.7-on-centos-6.3.-Follow-this-sequence-exactly-for-centos-machine-only
RUN wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz \
	&& tar xf Python-2.7.11.tar.xz \
	&& cd Python-2.7.11 \
	&& ./configure --prefix=/usr/local/python2.7 --enable-shared \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" altinstall \
	&& echo "/usr/local/lib" > /etc/ld.so.conf.d/usrLocalLib.conf \
	&& ldconfig \
	&& cd .. && rm -f Python-2.7.11.tar.xz && rm -rf Python-2.7.11

# pip for Python 2
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
	&& /usr/local/python2.7/bin/python2.7 get-pip.py \
	&& rm -f get-pip.py

# Python 3
RUN wget https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tar.xz \
	&& tar xf Python-3.5.1.tar.xz && cd Python-3.5.1 \
	&& ./configure --prefix=/usr/local --enable-shared \
	&& echo "zlib zlibmodule.c -I\$(prefix)/include -L\$(exec_prefix)/lib -lz" >> ./Modules/Setup \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" altinstall \
	&& ln -s /usr/local/bin/python3.5 /usr/local/bin/python3 \
	&& ln -s /usr/local/bin/pip3.5 /usr/local/bin/pip3 \
	&& ldconfig \
	&& cd .. && rm -f Python-3.5.1.tar.xz && rm -rf Python-3.5.1

# Upgrade pip
# https://pip.pypa.io/en/stable/installing/#upgrading-pip
RUN pip2 install -U pip

RUN pip3 install -U pip

# LLVM deps
RUN yum -y install libedit-devel libffi-devel swig python-devel

# LLVM
# Clang /tools/clang
# CompilerRT /projects/compiler-rt
# libc++ /projects/libcxx
# libc++abi /projects/libcxxabi
# lldb /tools/lldb
RUN wget http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz \
	&& wget http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz \
	&& wget http://llvm.org/releases/3.7.1/compiler-rt-3.7.1.src.tar.xz \
	&& wget http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz \
	&& wget http://llvm.org/releases/3.7.1/libcxxabi-3.7.1.src.tar.xz \
	&& wget http://llvm.org/releases/3.7.1/lldb-3.7.1.src.tar.xz \
	&& mkdir llvm \
	&& tar xf llvm-3.7.1.src.tar.xz -C llvm --strip-components=1 \
	&& mkdir llvm/tools/clang \
	&& tar xf cfe-3.7.1.src.tar.xz -C llvm/tools/clang --strip-components=1 \
	&& mkdir llvm/projects/compiler-rt \
	&& tar xf compiler-rt-3.7.1.src.tar.xz -C llvm/projects/compiler-rt --strip-components=1 \
	&& mkdir llvm/projects/libcxx \
	&& tar xf libcxx-3.7.1.src.tar.xz -C llvm/projects/libcxx --strip-components=1 \
	&& mkdir llvm/projects/libcxxabi \
	&& tar xf libcxxabi-3.7.1.src.tar.xz -C llvm/projects/libcxxabi --strip-components=1 \
	&& mkdir llvm/tools/lldb \
	&& tar xf lldb-3.7.1.src.tar.xz -C llvm/tools/lldb --strip-components=1 \
	&& rm -f *tar.xz

# http://llvm.org/docs/CMake.html
# find / -iname 'ffi.h'
# cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_PIC=ON -DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/usr/lib64/libffi-3.0.5/include  ../llvm
RUN mkdir ~/llvm_build \
	&& cd ~/llvm_build \
	&& ../llvm/configure --enable-shared

RUN cd ~/llvm_build \
	&& make ENABLE_OPTIMIZED=1 DISABLE_ASSERTIONS=1 -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& ln -s /usr/local/lib/libLLVM-3.7.1.so /usr/local/lib/libLLVM.so \
	&& ldconfig \
	&& cd .. && rm -rf llvm_build && rm -rf llvm

# node
RUN wget https://github.com/nodejs/node/archive/v5.10.0.tar.gz \
	&& tar xf v5.10.0.tar.gz && cd node-5.10.0 \
	&& ./configure \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -f v5.10.0.tar.gz && rm -rf node-5.10.0

# update npm
RUN npm update npm -g

# R
# CentOS packages for R that are not available for Redhat6, but are compatible
RUN wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/lapack-devel-3.4.2-5.el7.x86_64.rpm' \
	&& wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/blas-devel-3.4.2-5.el7.x86_64.rpm' \
	&& wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/libicu-devel-50.1.2-15.el7.x86_64.rpm' \
	&& wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/texinfo-tex-5.1-4.el7.x86_64.rpm'

RUN	yum -y localinstall *.rpm \
	&& rm -f *.rpm

RUN yum install -y \
	unixodbc-devel \
	QuantLib \
	QuantLib-devel \
	boost \
	boost-devel \
	libxml2 \
	libxml2-devel \
	R

# Set default CRAN Mirror
RUN echo 'options(repos = c(CRAN="http://www.vps.fmvz.usp.br/CRAN/"))' >> /usr/lib64/R/library/base/R/Rprofile

# RStudio
RUN wget https://download2.rstudio.org/rstudio-server-rhel-0.99.893-x86_64.rpm \
	&& echo "4f3b104e7fd84073c351b008da68272a  rstudio-server-rhel-0.99.893-x86_64.rpm" > RSTUDIOMD5 \
	&& RESULT=$(md5sum -c RSTUDIOMD5) \
	&& echo ${RESULT} > ~/check-rstudio-md5.txt \
	&& yum -y install --nogpgcheck rstudio-server-rhel-0.99.893-x86_64.rpm \
	&& rm -f rstudio-server-rhel-0.99.893-x86_64.rpm && rm -f RSTUDIOMD5

# Libreoffice
RUN wget http://download.documentfoundation.org/libreoffice/stable/5.1.1/rpm/x86_64/LibreOffice_5.1.1_Linux_x86-64_rpm.tar.gz \
	&& echo "27f5028c54ea8400d11db5654ddc53d5  LibreOffice_5.1.1_Linux_x86-64_rpm.tar.gz" > LIBREOFFICEMD5 \
	&& RESULT=$(md5sum -c LIBREOFFICEMD5) \
	&& echo ${RESULT} > ~/check-libreoffice-md5.txt \
	&& tar xf LibreOffice_5.1.1_Linux_x86-64_rpm.tar.gz \
	&& cd LibreOffice_5.1.1.3_Linux_x86-64_rpm/RPMS \
	&& yum -y install *.rpm \
	&& cd && rm -f LIBREOFFICEMD5 && rm -f LibreOffice_5.1.1_Linux_x86-64_rpm.tar.gz \
	&& rm -rf LibreOffice_5.1.1.3_Linux_x86-64_rpm

# Shiny
RUN R -e 'install.packages("shiny")' \
	&& wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.2.786-rh5-x86_64.rpm \
	&& echo "45160b08eed65c89e0a9d03c58eba595  shiny-server-1.4.2.786-rh5-x86_64.rpm" > SHINYSERVERMD5 \
	&& RESULT=$(md5sum -c SHINYSERVERMD5) \
	&& echo ${RESULT} > ~/check-shiny-server-md5.txt \
	&& yum -y install --nogpgcheck shiny-server-1.4.2.786-rh5-x86_64.rpm \
	&& cd && rm -f SHINYSERVERMD5 && rm -f shiny-server-1.4.2.786-rh5-x86_64.rpm

# Julia
RUN wget https://github.com/JuliaLang/julia/archive/v0.4.5.tar.gz \
        && tar xf v0.4.5.tar.gz

ADD julia-Make.user julia-0.4.5/Make.user

ADD cpuid cpuid

RUN cd cpuid && make

RUN cpuid/cpuid >> julia-0.4.5/Make.user

RUN cd julia-0.4.5 \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -rf julia-0.4.5 && rm -f v0.4.5.tar.gz \
	&& ln -s /usr/local/julia/bin/julia /usr/local/bin/julia

# Init package folder on root's home folder
RUN julia -e 'Pkg.init()'

# Jupyter
# Add python2.7 kernel: https://github.com/jupyter/jupyter/issues/71
RUN pip2 install \
	IPython \
	notebook \
	ipykernel \
	ipyparallel \
	enum34 \
	&& /usr/local/python2.7/bin/python2.7 -m ipykernel install

RUN pip3 install \
	IPython \
	jupyterhub \
	notebook \
	ipykernel \
	ipyparallel \
	enum34 \
	&& python3 -m ipykernel install

RUN npm install -g configurable-http-proxy

# ipywidgets not working for now...
# ipywidgets
# https://ipywidgets.readthedocs.org/en/latest/dev_install.html

#RUN git clone https://github.com/ipython/ipywidgets
#RUN wget https://github.com/ipython/ipywidgets/archive/4.1.1.tar.gz \
#	&& tar xf 4.1.1.tar.gz

#RUN cd ipywidgets-4.1.1 \
#	&& pip2 install -v -e . \
#	&& pip3 install -v -e . \
#	&& cd jupyter-js-widgets \
# 	&& npm install \
# 	&& cd ../widgetsnbextension \
# 	&& npm install \
# 	&& npm run update:widgets \
# 	&& pip2 install -v -e . \
# 	&& pip3 install -v -e .
 
# RUN rm -rf ipywidgets-4.1.1 && rm -f 4.1.1.tar.gz

# Support for other languages
# https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

# Add Julia kernel
# https://github.com/JuliaLang/IJulia.jl
# https://github.com/JuliaLang/IJulia.jl/issues/341
RUN julia -e 'Pkg.add("IJulia"); using IJulia'

# registers global kernel
RUN cp -r ~/.local/share/jupyter/kernels/julia-0.4 /usr/local/share/jupyter/kernels 

# rewrite julia's kernel configuration
ADD julia-kernel.json /usr/local/share/jupyter/kernels/julia-0.4/kernel.json

# R
# http://irkernel.github.io/installation/
RUN yum -y install czmq-devel

RUN R -e 'install.packages(c("rzmq","repr","IRkernel","IRdisplay"), repos = c("http://irkernel.github.io/", getOption("repos")),type = "source")' \
	&& R -e 'IRkernel::installspec(user = FALSE)'

# coin SYMPHONY
# https://projects.coin-or.org/SYMPHONY
RUN git clone --branch=stable/5.6 https://github.com/coin-or/SYMPHONY SYMPHONY-5.6 \
	&& cd SYMPHONY-5.6 \
	&& git clone --branch=stable/0.8 https://github.com/coin-or-tools/BuildTools/ \
	&& chmod u+x ./BuildTools/get.dependencies.sh \
	&& ./BuildTools/get.dependencies.sh fetch \
	&& ./configure \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -rf SYMPHONY-5.6

#################
## LIBS
#################

RUN yum -y install libpng libpng-devel libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel libxslt-devel libxml2-devel pandoc glpk-devel

RUN yum -y install texlive-*

ADD libs libs

RUN cd libs && make && ./install_libs

RUN cd libs && source ./install_numba.sh

# http://ipyparallel.readthedocs.org/en/latest/
RUN ipcluster nbextension enable

####################
## Services
####################

# 8787 for RStudio
# 8000 for Jupyter
EXPOSE 8787 8000

CMD /usr/lib/rstudio-server/bin/rserver && jupyterhub --no-ssl
