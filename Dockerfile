
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
    cronie \
    czmq \
    expat-devel \
    file \
    flex \
    fontconfig-devel \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    gdb \
    gettext-devel \
    glibc-devel \
    gperf \
    java-1.8.0-openjdk-devel \
    lynx \
    libaio \
    libattr-devel \
    libcurl \
    libcurl-devel \
    libedit-devel libffi-devel \
    libgcc \
    libstdc++-static \
    libtool \
    m4 \
    make \
    man \
    nano \
    nload \
    neovim \
    htop \
    openssl \
    openssl098e \
    openssl-devel \
    patch \
    perl-ExtUtils-MakeMaker \
    svn \
    unzip \
    valgrind \
    ruby \
    ruby-devel \
    sqlite \
    sqlite-devel \
    squashfs-tools \
    telnet \
    vim \
    wget \
    zeromq \
    zlib \
    zlib-devel \
    zip \
    && yum clean all

ENV PATH /usr/local/sbin:/usr/local/bin:$PATH

ENV CPATH /usr/include/glpk

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib64

# TeX
RUN yum -y install perl-Tk perl-Digest-MD5 xorriso && yum clean all

ADD texlive.profile texlive.profile

# Offline TeX Live installation
# https://tex.stackexchange.com/questions/370256/how-to-install-tex-live-offline-on-ubuntu
# https://stackoverflow.com/questions/22028795/is-it-possible-to-mount-an-iso-inside-a-docker-container
# http://www.gnu.org/software/xorriso/
# non-interactive http://www.tug.org/pipermail/tex-live/2008-June/016323.html
# Official link: http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

ENV TEXLIVE_VERSION 2019

RUN wget http://mirrors.rit.edu/CTAN/systems/texlive/Images/texlive$TEXLIVE_VERSION.iso \
    && wget http://mirrors.rit.edu/CTAN/systems/texlive/Images/texlive$TEXLIVE_VERSION.iso.md5 \
    && RESULT=$(md5sum -c texlive$TEXLIVE_VERSION.iso.md5) \
    && echo ${RESULT} > ~/check-texlive-md5.txt \
    && osirrox -indev ./texlive$TEXLIVE_VERSION.iso -extract / ./texlive_install \
    && rm -f texlive$TEXLIVE_VERSION.iso \
    && ./texlive_install/install-tl -profile ./texlive.profile \
    && rm -rf texlive_install

# Uncomment lines below to update TeX Live to latest packages
# Sets texlive update mirror
# https://tex.stackexchange.com/questions/378210/installing-tl-using-iso-leads-to-local-unknown-repository-tlpdb
#RUN tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
#RUN tlmgr update --self --all --reinstall-forcibly-removed

ENV PATH /usr/local/texlive/distribution/bin/x86_64-linux:$PATH

# GIT - https://git-scm.com/
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
ENV GIT_VER 2.24.1

RUN wget https://www.kernel.org/pub/software/scm/git/git-$GIT_VER.tar.gz \
    && tar xf git-$GIT_VER.tar.gz && cd git-$GIT_VER \
    && make -j"$(nproc --all)" prefix=/usr/local all \
    && make prefix=/usr/local -j"$(nproc --all)" install \
    && cd .. && rm -f git-$GIT_VER.tar.gz && rm -rf git-$GIT_VER

# Makes git use https by default
RUN git config --global url."https://".insteadOf git://

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
ENV CMAKE_VER_MAJ 3.16
ENV CMAKE_VER_MIN .1
ENV CMAKE_VER $CMAKE_VER_MAJ$CMAKE_VER_MIN

RUN wget https://cmake.org/files/v$CMAKE_VER_MAJ/cmake-$CMAKE_VER.tar.gz \
    && tar xf cmake-$CMAKE_VER.tar.gz && cd cmake-$CMAKE_VER \
    && ./bootstrap && make -j"$(nproc --all)" && make -j"$(nproc --all)" install \
    && cd .. && rm -rf cmake-$CMAKE_VER && rm -f cmake-$CMAKE_VER.tar.gz

ENV CMAKE_ROOT /usr/local/share/cmake-$CMAKE_VER_MAJ

# node https://nodejs.org/en/ - https://tecadmin.net/install-latest-nodejs-and-npm-on-centos/
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y nodejs

# reinstall npm with the lastest version
# Workaround https://github.com/npm/npm/issues/15558
# with https://github.com/npm/npm/issues/15611#issuecomment-289133810
RUN npm install npm \
    && rm -rf /usr/local/lib/node_modules \
    && mv node_modules /usr/local/lib/

# Makes npm work behind proxy if http_proxy variable is set
RUN npm config set proxy ${http_proxy} \
    && npm config set https-proxy ${https_proxy} \
    && npm config set registry http://registry.npmjs.org/ \
    && npm set strict-ssl false

# Anaconda
# https://repo.continuum.io/archive
ENV CONDA_VER 2019.10

ENV PATH $PATH:/usr/local/conda/anaconda3/bin

RUN wget https://repo.continuum.io/archive/Anaconda3-$CONDA_VER-Linux-x86_64.sh \
    && bash Anaconda3-$CONDA_VER-Linux-x86_64.sh -b -p /usr/local/conda/anaconda3 \
    && rm -f Anaconda3-$CONDA_VER-Linux-x86_64.sh \
    && conda update -n base conda -y

RUN conda update --all

# Install py2 and py3 envs, and registers jupyterhub kernels
# https://github.com/jupyter/jupyter/issues/71

# install everything (except JupyterHub itself) with Python 2 and 3. Jupyter is included in Anaconda.
RUN conda create -n py3 python=3 anaconda ipykernel \
    && conda create -n py2 python=2 anaconda ipykernel

# Set PYTHON env variable to point to Python3. This will be used by PyCall.jl julia package.
ENV PYTHON /usr/local/conda/anaconda3/envs/py3/bin/python

# register py2 kernel
RUN source activate py2 && python -m ipykernel install

RUN conda install -c conda-forge jupyterhub -y

# ipywidgets: https://github.com/ipython/ipywidgets
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Jupyterlab: https://github.com/jupyterlab/jupyterlab
RUN source activate py3 && conda install -c conda-forge jupyterlab -y

# Integration between jupyterhub and jupyterlab
# not working: https://github.com/jupyterhub/jupyterlab-hub/issues/78
#RUN jupyter labextension install @jupyterlab/hub-extension

# Support for other languages
# https://github.com/jupyter/jupyter/wiki/Jupyter-kernels

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
ENV RSTUDIO_VER 1.2.5019

RUN wget https://download2.rstudio.org/server/centos6/x86_64/rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm \
    && echo "748bd5a45f1c386b538da9be83203c24 rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm" > RSTUDIOMD5 \
    && RESULT=$(md5sum -c RSTUDIOMD5) \
    && echo ${RESULT} > ~/check-rstudio-md5.txt \
    && yum -y install --nogpgcheck rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm \
    && yum clean all \
    && rm -f rstudio-server-rhel-$RSTUDIO_VER-x86_64.rpm && rm -f RSTUDIOMD5

# Shiny - https://www.rstudio.com/products/shiny/download-server/
ENV SHINY_VER 1.5.12.933

RUN R -e 'install.packages("shiny", repos="https://cran.rstudio.com/")' \
    && wget https://download3.rstudio.org/centos6.3/x86_64/shiny-server-$SHINY_VER-x86_64.rpm \
    && echo "af1daa27220cef698efa600072509a25 shiny-server-$SHINY_VER-x86_64.rpm" > SHINYSERVERMD5 \
    && RESULT=$(md5sum -c SHINYSERVERMD5) \
    && echo ${RESULT} > ~/check-shiny-server-md5.txt \
    && yum -y install --nogpgcheck shiny-server-$SHINY_VER-x86_64.rpm \
    && yum clean all \
    && cd && rm -f SHINYSERVERMD5 && rm -f shiny-server-$SHINY_VER-x86_64.rpm

# Julia - https://julialang.org/downloads/
ENV JULIA_VER_MAJ 1.3
ENV JULIA_VER_MIN .0
ENV JULIA_VER $JULIA_VER_MAJ$JULIA_VER_MIN

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_VER_MAJ/julia-$JULIA_VER-linux-x86_64.tar.gz \
        && mkdir /usr/local/julia \
        && tar xf julia-$JULIA_VER-linux-x86_64.tar.gz --directory /usr/local/julia --strip-components=1 \
        && ln -s /usr/local/julia/bin/julia /usr/local/bin/julia \
        && rm -f julia-$JULIA_VER-linux-x86_64.tar.gz

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

# R
# http://irkernel.github.io/installation/
RUN yum -y install czmq-devel && yum clean all

RUN R -e "install.packages('IRkernel')"

RUN R -e "IRkernel::installspec(user = FALSE)"

# Optional configuration file for svn
ADD svn-servers /etc/subversion/servers

# coin SYMPHONY
# https://github.com/coin-or/SYMPHONY
ENV SYMPHONY_VER 5.6

RUN git clone https://www.github.com/coin-or/coinbrew \
    && cd coinbrew \
    && ./coinbrew fetch --no-prompt SYMPHONY:stable/$SYMPHONY_VER \
    && ./coinbrew build --no-prompt SYMPHONY --prefix=/usr/local --parallel-jobs="$(nproc --all)" \
    && ./coinbrew install SYMPHONY \
    && cd .. && rm -rf coinbrew

# bash Jupyter kernel
RUN source activate py3 && pip install bash_kernel \
    && python3 -m bash_kernel.install

# pigz: http://zlib.net/pigz/
ENV PIGZ_VER 2.4

RUN wget http://zlib.net/pigz/pigz-$PIGZ_VER.tar.gz \
    && tar xf pigz-$PIGZ_VER.tar.gz \
    && cd pigz-$PIGZ_VER \
    && make -j"$(nproc --all)" \
    && cp pigz /usr/local/bin \
    && cp unpigz /usr/local/bin \
    && cd .. && rm -rf pigz-$PIGZ_VER && rm -f pigz-$PIGZ_VER.tar.gz

# uchardet: https://www.freedesktop.org/wiki/Software/uchardet/
RUN git clone --depth=1 https://anongit.freedesktop.org/git/uchardet/uchardet.git \
    && cd uchardet \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release . \
    && make -j"$(nproc --all)" \
    && make install \
    && cd .. && rm -rf uchardet

ENV JAVA_HOME /etc/alternatives/java_sdk

# Redis (https://redis.io)
RUN wget http://download.redis.io/redis-stable.tar.gz \
    && tar xf redis-stable.tar.gz \
    && cd redis-stable \
    && make -j"$(nproc --all)" \
    && make install \
    && cd .. && rm -rf redis-stable && rm -f redis-stable.tar.gz

# MongoDB (https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)
ADD mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo
RUN yum install -y mongodb-org

#################
## LIBS
#################

# Optional libraries for packages
#RUN yum -y install \
#   cyrus-sasl-devel \
#   freeglut \
#   freeglut-devel \
#   freetype-devel \
#   geos-devel \
#   gdal-devel \
#   glpk-devel \
#   gsl-devel \
#   gtk3-devel \
#   hdf5 \
#   ImageMagick \
#   lcms2-devel \
#   libjpeg-devel \
#   libpng \
#   libpng-devel \
#   libtiff-devel \
#   libtool \
#   libwebp-devel \
#   libxslt-devel \
#   libxml2-devel \
#   libzip-devel \
#   mpfr-devel \
#   pandoc \
#   proj-devel \
#   proj-epsg \
#   proj-nad \
#   tcl-devel \
#   tk-devel \
#   && yum clean all

RUN yum -y install \
    hdf5 \
    libxml2-devel \
    libzip-devel \
    && yum clean all

# http://ipyparallel.readthedocs.org/en/latest/
#RUN ipcluster nbextension enable

# Improve link to shared libraries
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib64/R/lib:/usr/local/lib:/lib:/usr/lib/jvm/jre/lib/amd64/server:/usr/lib/jvm/jre/lib/amd64:/usr/lib/jvm/java/lib/amd64:/usr/java/packages/lib/amd64:/lib:/usr/lib:/usr/local/lib

# ffmpeg
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro \
    && rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm \
    && yum install ffmpeg ffmpeg-devel -y

# Altair - https://altair-viz.github.io/installation.html
RUN conda install altair --channel conda-forge -y

# Plotly for Python
RUN conda install plotly -y

####################
## Services
####################

# 8787 for RStudio
# 8000 for Jupyter
EXPOSE 8787 8000

ADD jupyterhub_config.py jupyterhub_config.py

ENV TERM xterm

CMD /usr/lib/rstudio-server/bin/rserver \
    && jupyterhub --no-ssl -f jupyterhub_config.py
