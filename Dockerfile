
# docker build -t math-server:latest --build-arg http_proxy="http://proxy:8080" --build-arg https_proxy="http://proxy:8080" .

# In case you're building the image behind a proxy, use
# docker build -t math-server:latest --build-arg http_proxy="http://proxy:8080" --build-arg https_proxy="http://proxy:8080" .

# 8787 for RStudio
# 8000 for Jupyter

# docker run -d -p 8787:8787 -p 8000:8000 --name ms1 math-server

FROM centos:7

MAINTAINER felipenoris <felipenoris@users.noreply.github.com>

WORKDIR /root

RUN yum update -y && yum install -y epel-release && yum clean all

RUN yum update -y && yum install -y \
	p7zip \
	p7zip-plugins \
	bison \
	bzip2 \
	bzip2-devel \
	cmake \
	curl-devel \
	czmq \
	expat-devel \
	flex \
	gcc \
	gcc-c++ \
	gcc-gfortran \
	gdb \
	gettext-devel \
	glibc-devel \
	java-1.8.0-openjdk-devel \
	lynx \
	libattr-devel \
	libcurl \
	libcurl-devel \
	libedit-devel libffi-devel \
	libgcc \
	libstdc++-static \
	m4 \
	make \
	man \
	memcached \
	mongodb \
	mongodb-server \
	nano \
	nload \
	htop \
	openssl \
	openssl098e \
	openssl-devel \
	patch \
	perl-ExtUtils-MakeMaker \
	svn \
	unzip \
	valgrind \
	sqlite \
	sqlite-devel \
	telnet \
	vim \
	wget \
	zlib \
	zlib-devel \
	zip \
	&& yum clean all

ENV PATH /usr/local/sbin:/usr/local/bin:$PATH

ENV CPATH /usr/include/glpk

ENV LD_LIBRARY_PATH /usr/local/lib

# GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
ENV GIT_VER 2.12.1

RUN wget https://www.kernel.org/pub/software/scm/git/git-$GIT_VER.tar.gz \
	&& tar xf git-$GIT_VER.tar.gz && cd git-$GIT_VER \
	&& make -j"$(nproc --all)" prefix=/usr/local all \
	&& make prefix=/usr/local -j"$(nproc --all)" install \
	&& cd .. && rm -f git-$GIT_VER.tar.gz && rm -rf git-$GIT_VER

# Makes git use https by default
RUN git config --global url."https://".insteadOf git://

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
ENV CMAKE_VER_MAJ 3.7
ENV CMAKE_VER_MIN .2
ENV CMAKE_VER $CMAKE_VER_MAJ$CMAKE_VER_MIN

RUN wget https://cmake.org/files/v$CMAKE_VER_MAJ/cmake-$CMAKE_VER.tar.gz \
	&& tar xf cmake-$CMAKE_VER.tar.gz && cd cmake-$CMAKE_VER \
	&& ./bootstrap && make -j"$(nproc --all)" && make -j"$(nproc --all)" install \
	&& cd .. && rm -rf cmake-$CMAKE_VER && rm -f cmake-$CMAKE_VER.tar.gz

ENV CMAKE_ROOT /usr/local/share/cmake-$CMAKE_VER_MAJ

# pip for Python 2
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
	&& python2 get-pip.py \
	&& rm -f get-pip.py

# Python 3
ENV PYTHON3_VER_MAJ 3.6
ENV PYTHON3_VER_MIN .1
ENV PYTHON3_VER $PYTHON3_VER_MAJ$PYTHON3_VER_MIN

RUN wget https://www.python.org/ftp/python/$PYTHON3_VER/Python-$PYTHON3_VER.tar.xz \
	&& tar xf Python-$PYTHON3_VER.tar.xz && cd Python-$PYTHON3_VER \
	&& ./configure --prefix=/usr/local --enable-shared --with-cxx-main=/usr/bin/g++ \
	&& echo "zlib zlibmodule.c -I\$(prefix)/include -L\$(exec_prefix)/lib -lz" >> ./Modules/Setup \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" altinstall \
	&& ln -s /usr/local/bin/python$PYTHON3_VER_MAJ /usr/local/bin/python3 \
	&& ln -s /usr/local/bin/pip$PYTHON3_VER_MAJ /usr/local/bin/pip3 \
	&& ldconfig \
	&& cd .. && rm -f Python-$PYTHON3_VER.tar.xz && rm -rf Python-$PYTHON3_VER

# Upgrade pip
# https://pip.pypa.io/en/stable/installing/#upgrading-pip
RUN pip2 install -U pip

RUN pip3 install -U pip

# LLVM deps
RUN yum -y install \
	libedit-devel \
	libffi-devel \
	swig \
	python-devel \
	&& yum clean all

# LLVM
# Clang /tools/clang
# CompilerRT /projects/compiler-rt
# libc++ /projects/libcxx
# libc++abi /projects/libcxxabi
# lldb /tools/lldb
ENV LLVM_VER 3.7.1

RUN wget http://llvm.org/releases/$LLVM_VER/llvm-$LLVM_VER.src.tar.xz \
	&& wget http://llvm.org/releases/$LLVM_VER/cfe-$LLVM_VER.src.tar.xz \
	&& wget http://llvm.org/releases/$LLVM_VER/compiler-rt-$LLVM_VER.src.tar.xz \
	&& wget http://llvm.org/releases/$LLVM_VER/libcxx-$LLVM_VER.src.tar.xz \
	&& wget http://llvm.org/releases/$LLVM_VER/libcxxabi-$LLVM_VER.src.tar.xz \
	&& wget http://llvm.org/releases/$LLVM_VER/lldb-$LLVM_VER.src.tar.xz \
	&& mkdir llvm \
	&& tar xf llvm-$LLVM_VER.src.tar.xz -C llvm --strip-components=1 \
	&& mkdir llvm/tools/clang \
	&& tar xf cfe-$LLVM_VER.src.tar.xz -C llvm/tools/clang --strip-components=1 \
	&& mkdir llvm/projects/compiler-rt \
	&& tar xf compiler-rt-$LLVM_VER.src.tar.xz -C llvm/projects/compiler-rt --strip-components=1 \
	&& mkdir llvm/projects/libcxx \
	&& tar xf libcxx-$LLVM_VER.src.tar.xz -C llvm/projects/libcxx --strip-components=1 \
	&& mkdir llvm/projects/libcxxabi \
	&& tar xf libcxxabi-$LLVM_VER.src.tar.xz -C llvm/projects/libcxxabi --strip-components=1 \
	&& mkdir llvm/tools/lldb \
	&& tar xf lldb-$LLVM_VER.src.tar.xz -C llvm/tools/lldb --strip-components=1 \
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
	&& ln -s /usr/local/lib/libLLVM-$LLVM_VER.so /usr/local/lib/libLLVM.so \
	&& ldconfig \
	&& cd .. && rm -rf llvm_build && rm -rf llvm

# node
ENV NODE_VER 7.6.0

RUN wget https://github.com/nodejs/node/archive/v$NODE_VER.tar.gz \
	&& tar xf v$NODE_VER.tar.gz && cd node-$NODE_VER \
	&& ./configure \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -f v$NODE_VER.tar.gz && rm -rf node-$NODE_VER

# reinstall npm with the lastest version
RUN npm cache clean \
	&& curl -L https://npmjs.org/install.sh | sh

# Makes npm work behind proxy if http_proxy variable is set
RUN npm config set proxy ${http_proxy} \
	&& npm config set https-proxy ${https_proxy} \
	&& npm config set registry http://registry.npmjs.org/ \
	&& npm set strict-ssl false

# TeX
RUN yum -y install perl-Tk perl-Digest-MD5 && yum clean all

ADD texlive.profile texlive.profile

# non-interactive http://www.tug.org/pipermail/tex-live/2008-June/016323.html
# Official link: http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN wget http://mirrors.rit.edu/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz \
	&& mkdir install-tl \
	&& tar xf install-tl-unx.tar.gz -C install-tl --strip-components=1 \
	&& ./install-tl/install-tl -profile ./texlive.profile --location http://mirrors.rit.edu/CTAN/systems/texlive/tlnet \
	&& rm -rf install-tl && rm -f install-tl-unx.tar.gz

ENV PATH /usr/local/texlive/distribution/bin/x86_64-linux:$PATH

# R
RUN yum -y install \
	lapack-devel \
	blas-devel \
	libicu-devel \
	unixodbc-devel \
	boost \
	boost-devel \
	libxml2 \
	libxml2-devel \
	R \
	&& yum clean all

# Set default CRAN Mirror
RUN echo 'options(repos = c(CRAN="https://ftp.osuosl.org/pub/cran/"))' >> /usr/lib64/R/library/base/R/Rprofile

# RStudio - https://www.rstudio.com/products/rstudio/download-server/
ENV RSTUDIO_VER 1.0.136

RUN wget https://download2.rstudio.org/rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm \
	&& echo "ed7ebef1eb47f19cdfe05288b77c3336  rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm" > RSTUDIOMD5 \
	&& RESULT=$(md5sum -c RSTUDIOMD5) \
	&& echo ${RESULT} > ~/check-rstudio-md5.txt \
	&& yum -y install --nogpgcheck rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm \
	&& yum clean all \
	&& rm -f rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm && rm -f RSTUDIOMD5

# Libreoffice - https://www.libreoffice.org/download/libreoffice-fresh/
# Linux x64 rpm
ENV LIBREOFFICE_VER 5.3.0
ENV LIBREOFFICE_VER_MINOR .3

RUN wget http://mirror.nbtelecom.com.br/tdf/libreoffice/stable/$LIBREOFFICE_VER/rpm/x86_64/LibreOffice_${LIBREOFFICE_VER}_Linux_x86-64_rpm.tar.gz \
	&& echo "de0214a9ec1c4be1abf178c5144becc0  LibreOffice_${LIBREOFFICE_VER}_Linux_x86-64_rpm.tar.gz" > LIBREOFFICEMD5 \
	&& RESULT=$(md5sum -c LIBREOFFICEMD5) \
	&& echo ${RESULT} > ~/check-libreoffice-md5.txt \
	&& tar xf LibreOffice_${LIBREOFFICE_VER}_Linux_x86-64_rpm.tar.gz \
	&& cd LibreOffice_${LIBREOFFICE_VER}${LIBREOFFICE_VER_MINOR}_Linux_x86-64_rpm/RPMS \
	&& yum -y install *.rpm \
	&& yum clean all \
	&& cd && rm -f LIBREOFFICEMD5 && rm -f LibreOffice_${LIBREOFFICE_VER}_Linux_x86-64_rpm.tar.gz \
	&& rm -rf LibreOffice_${LIBREOFFICE_VER}${LIBREOFFICE_VER_MINOR}_Linux_x86-64_rpm

# Shiny - https://www.rstudio.com/products/shiny/download-server/
ENV SHINY_VER 1.5.1.834

RUN R -e 'install.packages("shiny")' \
	&& wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-$SHINY_VER-rh5-x86_64.rpm \
	&& echo "2423ef792ee5b2aca5fbcf47cd958770  shiny-server-$SHINY_VER-rh5-x86_64.rpm" > SHINYSERVERMD5 \
	&& RESULT=$(md5sum -c SHINYSERVERMD5) \
	&& echo ${RESULT} > ~/check-shiny-server-md5.txt \
	&& yum -y install --nogpgcheck shiny-server-$SHINY_VER-rh5-x86_64.rpm \
	&& yum clean all \
	&& cd && rm -f SHINYSERVERMD5 && rm -f shiny-server-$SHINY_VER-rh5-x86_64.rpm

# Julia
ENV JULIA_VER_MAJ 0.5
ENV JULIA_VER_MIN .1
ENV JULIA_VER $JULIA_VER_MAJ$JULIA_VER_MIN

RUN wget https://github.com/JuliaLang/julia/releases/download/v$JULIA_VER/julia-$JULIA_VER-full.tar.gz \
		&& tar xf julia-$JULIA_VER-full.tar.gz

ADD julia-Make.user julia-$JULIA_VER/Make.user

ADD cpuid cpuid

RUN cd cpuid && make

RUN cpuid/cpuid >> julia-$JULIA_VER/Make.user

RUN cd julia-$JULIA_VER \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& ln -s /usr/local/julia/bin/julia /usr/local/bin/julia \
	&& cd .. \
	&& rm -rf julia-$JULIA_VER && rm -f julia-$JULIA_VER-full.tar.gz && rm -rf cpuid

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

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
	&& python2 -m ipykernel install

RUN pip3 install \
	IPython \
	jupyterhub \
	notebook \
	ipykernel \
	ipyparallel \
	enum34 \
	&& python3 -m ipykernel install

RUN npm install -g configurable-http-proxy

# ipywidgets: https://github.com/ipython/ipywidgets
RUN pip3 install ipywidgets \
	&& pip2 install ipywidgets \
	&& jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Support for other languages
# https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

# Add Julia kernel
# https://github.com/JuliaLang/IJulia.jl
# https://github.com/JuliaLang/IJulia.jl/issues/341
# Depends on yum install czmq
RUN julia -e 'Pkg.add("IJulia"); using IJulia'

# registers global kernel
RUN cp -r ~/.local/share/jupyter/kernels/julia-$JULIA_VER_MAJ /usr/local/share/jupyter/kernels

# rewrite julia's kernel configuration
ADD julia-kernel.json /usr/local/share/jupyter/kernels/julia-$JULIA_VER_MAJ/kernel.json

# R
# http://irkernel.github.io/installation/
RUN yum -y install czmq-devel && yum clean all

RUN R -e 'install.packages(c("pbdZMQ", "devtools"))' \
	&& R -e 'devtools::install_github(paste0("IRkernel/", c("repr", "IRdisplay", "IRkernel")))'

RUN cp -r /usr/lib64/R/library/IRkernel/kernelspec /usr/local/share/jupyter/kernels/R

# Optional configuration file for svn
ADD svn-servers /etc/subversion/servers

# coin SYMPHONY
# https://projects.coin-or.org/SYMPHONY
ENV SYMPHONY_VER 5.6

RUN git clone --branch=stable/$SYMPHONY_VER https://github.com/coin-or/SYMPHONY SYMPHONY-$SYMPHONY_VER \
	&& cd SYMPHONY-$SYMPHONY_VER \
	&& git clone --branch=stable/0.8 https://github.com/coin-or-tools/BuildTools/ \
	&& chmod u+x ./BuildTools/get.dependencies.sh \
	&& ./BuildTools/get.dependencies.sh fetch --no-third-party \
	&& ./configure \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -rf SYMPHONY-$SYMPHONY_VER

# calysto-scheme Jupyter kernel
RUN pip3 install --upgrade calysto-scheme \
	&& python3 -m calysto_scheme install

# bash Jupyter kernel
RUN pip3 install bash_kernel \
	&& python3 -m bash_kernel.install

# pigz: http://zlib.net/pigz/
ENV PIGZ_VER 2.3.4

RUN wget http://zlib.net/pigz/pigz-$PIGZ_VER.tar.gz \
	&& tar xf pigz-$PIGZ_VER.tar.gz \
	&& cd pigz-$PIGZ_VER \
	&& make -j"$(nproc --all)" \
	&& cp pigz /usr/local/bin \
	&& cp unpigz /usr/local/bin \
	&& cd .. && rm -rf pigz-$PIGZ_VER && rm -f pigz-$PIGZ_VER.tar.gz

#################
## LIBS
#################

ENV JAVA_HOME /etc/alternatives/java_sdk

RUN yum -y install \
	cyrus-sasl-devel \
	freeglut \
	freeglut-devel \
	freetype-devel \
	glpk-devel \
	gsl-devel \
	gtk3-devel \
	hdf5 \
	ImageMagick \
	lcms2-devel \
	libjpeg-devel \
	libpng \
	libpng-devel \
	libtiff-devel \
	libtool \
	libwebp-devel \
	libxslt-devel \
	libxml2-devel \
	libzip-devel \
	pandoc \
	tcl-devel \
	tk-devel \
	&& yum clean all

# QuantLib http://quantlib.org/install/linux.shtml
# Depends on boost-devel and libtool CENTOS packages
ENV QUANTLIB_VER v1.8.1

RUN wget https://github.com/lballabio/QuantLib/archive/QuantLib-$QUANTLIB_VER.tar.gz \
	&& tar xf QuantLib-$QUANTLIB_VER.tar.gz \
	&& cd QuantLib-QuantLib-$QUANTLIB_VER \
	&& ./autogen.sh \
	&& ./configure --enable-intraday \
	&& make -j"$(nproc --all)" \
	&& make install \
	&& ldconfig \
	&& cd .. && rm -rf QuantLib-QuantLib-$QUANTLIB_VER && rm -f QuantLib-$QUANTLIB_VER.tar.gz

# http://ipyparallel.readthedocs.org/en/latest/
RUN ipcluster nbextension enable

# fix yum (issue #10)
RUN wget https://pypi.python.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz#md5=c94bdba01da6004fa38325e9bd6b9760 \
	&& tar xf pycurl-7.43.0.tar.gz \
	&& cd pycurl-7.43.0 \
	&& python setup.py --with-nss install \
	&& cd .. \
	&& rm -f pycurl-7.43.0.tar.gz \
	&& rm -rf pycurl-7.43.0

# Improve link to shared libraries
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib64/R/lib:/usr/local/lib:/lib:/usr/lib/jvm/jre/lib/amd64/server:/usr/lib/jvm/jre/lib/amd64:/usr/lib/jvm/java/lib/amd64:/usr/java/packages/lib/amd64:/lib:/usr/lib:/usr/local/lib

# Gambit-C
RUN git clone https://github.com/gambit/gambit.git \
	&& cd gambit \
	&& ./configure \
	&& make -j"$(nproc --all)" latest-release \
	&& ./configure --enable-single-host \
	&& make -j"$(nproc --all)" from-scratch \
	&& make check \
	&& make install \
	&& ln -s /usr/local/Gambit/bin/gsc /usr/local/bin/gsc \
	&& ln -s /usr/local/Gambit/bin/gsi /usr/local/bin/gsi \
	&& ln -s /usr/local/Gambit/bin/gambcomp-C /usr/local/bin/gambcomp-C \
	&& ln -s /usr/local/Gambit/bin/gambdoc /usr/local/bin/gambdoc \
	&& cd .. && rm -rf gambit

####################
## Libraries
####################

ADD libs libs

# Install packages
RUN cd libs && source ./libs_python2.sh

RUN cd libs && source ./libs_python3.sh

RUN cd libs && source ./libs_R.sh

RUN cd libs && julia libs_julia.jl

RUN cd libs && source ./install_JSAnimation.sh

RUN cd libs && source ./install_excel_readers.sh

# Update Python packages
RUN python2 ./libs/update_pkgs.py 2

RUN python3 ./libs/update_pkgs.py 3

####################
## Services
####################

# Memcached parameters
ENV MEMCACHE_MAXSIZE_MB 100
ENV MEMCACHE_MIN_ALLOC_SIZE 10

# 8787 for RStudio
# 8000 for Jupyter
EXPOSE 8787 8000

ADD jupyterhub_config.py jupyterhub_config.py

ENV TERM xterm

CMD memcached -d -u memcached -m $MEMCACHE_MAXSIZE_MB -n $MEMCACHE_MIN_ALLOC_SIZE \
	&& /usr/lib/rstudio-server/bin/rserver \
	&& jupyterhub --no-ssl -f jupyterhub_config.py
