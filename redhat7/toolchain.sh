#!/bin/sh

#ip addr # para listar as interfaces de rede
#dhclient eth0
#nmtui # para configurar interface de rede (marcar para iniciar no startup)

# default EC2 user is: ec2-user

# run this script with: sudo ./toolchain.sh

yum install -y wget
mkdir ~/tmp
cd ~/tmp
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat7/toolchain.sh
wget http://mirror.globo.com/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh epel-release-7-5.noarch.rpm
rm -f epel-release-7-5.noarch.rpm
yum -y update

# Ferramentas para compilação
yum -y install patch gcc-c++ gcc-gfortran bzip2 cmake curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

# new gcc
# CentOS6 vem com versão antiga do GCC.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.vultr.com/docs/how-to-install-gcc-on-centos-6
# https://gcc.gnu.org/install/build.html
yum -y install svn flex zip libgcc.i686 glibc-devel.i686 #texinfo-tex ja instalado
cd ~/tmp
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_5_3_0_release/
cd gcc_5_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_build
cd gcc_build
../gcc_5_3_0_release/configure
make -j 4 # incluir número de cores para compilação em paralelo, ver resultado de nproc
make install
hash -r # forget about old gcc

# Add new libraries to linker
echo "/usr/local/lib64" > usrLocalLib64.conf
mv usrLocalLib64.conf /etc/ld.so.conf.d/
ldconfig

# Checks if we got new gcc
gcc --version
g++ --version
gfortran --version
which gcc

# cleans gcc installation files
cd ..
rm -rf gcc_build && rm -rf gcc_5_3_0_release

# llvm needs CMake 2.8.12.2 or higher
# https://cmake.org/download/
cd ~/tmp
wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz
tar -xvzf cmake-3.4.1.tar.gz
cd cmake-3.4.1
./bootstrap && make && make install
# needs to logout and login (fixme)

# llvm https://github.com/llvm-mirror/llvm
# http://llvm.org/docs/CMake.html
# http://llvm.org/releases/download.html
cd ~/tmp
#git clone https://github.com/llvm-mirror/llvm.git
wget http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz
tar xf llvm-3.7.0.src.tar.xz
mkdir llvm_build
cmake ../llvm
cmake --build .
cmake --build . --target install
#cmake -DCMAKE_INSTALL_PREFIX=/tmp/llvm -P cmake_install.cmake # para escolher o diretorio
cd ..
rm -rf llvm_build
rm -rf llvm

# clang
# http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
wget http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
tar xf cfe-3.7.0.src.tar.xz
cd cfe-3.7.0.src

# new binutils
# CentOS6 vem com versão antiga do binutils.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.gnu.org/software/binutils/
cd ~/tmp
wget http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz
tar -xvzf binutils-2.25.tar.gz
cd binutils-2.25
# conferir comandos abaixo
./configure
make
make install
cd ..
rm -rf binutils-2.25
rm -f binutils-2.25.tar.gz

### GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
cd ~/tmp
wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
tar xzf git-2.6.4.tar.gz
cd git-2.6.4
make prefix=/usr/local all
make prefix=/usr/local install
cd ..
rm -f git-2.6.4.tar.gz && rm -rf git-2.6.4
git --version
###

# para o R
cd ~/tmp
wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/lapack-devel-3.4.2-5.el7.x86_64.rpm'
wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/blas-devel-3.4.2-5.el7.x86_64.rpm'
wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/libicu-devel-50.1.2-15.el7.x86_64.rpm'
wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/texinfo-tex-5.1-4.el7.x86_64.rpm'

yum -y localinstall lapack-devel-3.4.2-5.el7.x86_64.rpm
yum -y localinstall blas-devel-3.4.2-5.el7.x86_64.rpm
yum -y localinstall libicu-devel-50.1.2-15.el7.x86_64.rpm
yum -y localinstall texinfo-tex-5.1-4.el7.x86_64.rpm
rm -f *.rpm
yum -y install unixodbc-devel QuantLib QuantLib-devel boost boost-devel libxml2 libxml2-devel
yum -y install R

export CPATH=/usr/include/glpk

cd ~/tmp
wget 'http://www.omegahat.org/XMLRPC/XMLRPC_0.3-0.tar.gz'

R -e 'install.packages(c("RCurl", "XML"), repos="http://cran.fiocruz.br/")'
R -e 'install.packages("XMLRPC_0.3-0.tar.gz", repos = NULL, type = "source")'
R -e 'install.packages(c("data.table","XLConnect","reshape","ggplot2","vars","sqldf","shinyAce"), , repos="http://cran.fiocruz.br/")' # RODBC
R -e 'install.packages(c("iterators","RQuantLib","fArma", "fAsianOptions", "fBasics", "fBonds", "timeDate", "fExoticOptions", "fExtremes", "fGarch", "fImport", "fNonlinear", "fOptions", "timeSeries", "Hmisc","roxygen2","fPortfolio","relaimpo"), repos="http://cran.fiocruz.br/")' #Rsymphony, RQuantLib, Rglpk, fPortfolio

# RStudio
yum -y install openssl098e # Required only for RedHat/CentOS 6 and 7
cd ~/tmp
wget https://download2.rstudio.org/rstudio-server-rhel-0.99.489-x86_64.rpm
yum -y install --nogpgcheck rstudio-server-rhel-0.99.489-x86_64.rpm
rm -f rstudio-server-rhel-0.99.489-x86_64.rpm

# Default port is 8787. Changing to port 80 (default for http).

echo -e "www-port=80" | tee /etc/rstudio/rserver.conf
rstudio-server restart
rstudio-server verify-installation

#Importante: Veja que o processo do RStudio é configurado pelos arquivos contidos em /etc/rstudio (pasta padrão criada pela instalação do pacote), e gerenciado pelo comando rstudio-server.

#VERIFICAR SE HÁ OUTRA ESTRATÉGIA (USAR ARQUIVO rsession.conf)

# Feitas as instalações necessárias e configurado o RStudio para responder na porta 80, devemos configurá-lo
# para utilizar a autenticação integrada ao AD. Para isso, remetemos ao guia de administração do RStudio.
# Infelizmente, durante a instalação do ambiente de laboratório, identificamos que a documentação, em sua seção 5.3,
# indica a possibilidade de utilizar o parâmetro auth-pam-sessions-profile no arquivo de configuração do RStudio rserver.conf,
# sendo que o sistema não o reconhece como válido. Diante do cenário, o sistema foi monitorado e identificamos
# que as configurações do pam.d devem ser realizadas sobre o perfil /etc/pam.d /rstudio, incluindo-se neste as mesmas
# diretivas encontradas no perfil /etc/pam.d/su:

# cp -p /etc/rstudio/rserver.conf /etc/rstudio/rserver.conf.bak #faça um backup do arquivo de configuração do RStudio-server
# sudo echo auth-pam-sessions-profile=rstudio-session >> /etc/rstudio/rserver.conf #inclua o parâmetro para um novo perfil do pam.d a ser utilizado

# inclua os parâmetros do novo perfil (próximas X linhas)

#$ sudo echo auth sufficient pam_rootok.so >> /etc/pam.d/rstudio-session

#LibreOffice
#O pacote (RPM) do LibreOffice precisa ser baixado do site da fundação, neste caminho. Uma fez feito o download, transfira o arquivo para o servidor em que se deseja instalar, descompacte o arquivo e instale o produto:

#tar -xvf LibreOffice_4.3.3_Linux_x86-64_rpm.tar.gz cd LibreOffice_4.3.3.2_Linux_x86-64_rpm/

#cd RPMS/
#yum install *.rpm

#O Shiny-server deve ser baixado do site do fornecedor, conforme instrui o documento. É necessário, no entanto, realizar a instalação do Package do Shiny no R antes de realizar a instalação do shiny-server. Os comandos abaixo permitem realizar estas operações:

#$ sudo su - \
#-c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

#$ wget http://download3.rstudio.org/centos-5.9/x86_64/shiny-server-1.2.3.368-x86_64.rpm

#$ sudo yum install --nogpgcheck shiny-server-1.2.3.368-x86_64.rpm

#$ status shiny-server #confirme que o shiny-server está rodando. ex: shiny-server start/running, process 50862

#$ sudo /opt/shiny-server/bin/deploy-example default #deploy da aplicação exemplo

#Confirme o devido funcionamento do produto acessando http://<server-address>:3838/sample-apps/hello/.

#RMarkdown

#Este package do R é instalado diretamente pela ferramenta, sendo necessário, entretanto, ter instalado o pacote libcurl-devel (equivalente, no RHEL, ao libcurl4-gnutls-dev do Ubuntu). Em seguida, deve proceder com os comandos de instalação do package:

#$ sudo yum install libcurl-devel # ja deve ter sido instalado em etapas anteriores
#$ sudo su -c "R -e \"install.packages('RCurl', repos='http://cran.rstudio.com/')\""
#$ sudo su -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\"" $ sudo su -c "R -e \"devtools::install_github('hadley/devtools')\""
#$ sudo su -c "R" #abrirá a linha de comando do R. Digite as 3 linhas abaixo devtools::install_github('rstudio/rmarkdown')
#Cran mirror: digitar 11
#quit()
#Save workspace image? [y/n/c]: y
#$ sudo su -c "R -e \"devtools::install_github('rstudio/rmarkdown')\""
#$ sudo yum install texlive #já deve estar instalado

### JULIA
cd ~/tmp
git clone https://github.com/JuliaLang/julia.git
cd julia
git checkout release-0.4
make
sudo make install
rm -rf julia

# misc stuff
yum -y install clang # checar versao...
yum -y install valgrind # checar versao...
yum -y install lynx

# Python e Jupyter
# https://www.continuum.io/downloads
# http://jupyter.readthedocs.org/en/latest/install.html
# https://jupyter.org/
# http://conda.pydata.org/docs/test-drive.html#managing-conda
# Scipy http://www.scipy.org/install.html
cd ~/tmp
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.4.1-Linux-x86_64.sh

# anaconda part is still interactive...
bash Anaconda2-2.4.1-Linux-x86_64.sh

# instalacao default em ~/anaconda2/bin/conda

# ao final da instalacao, inclui path no .bashrc do usuario
# deslogar e logar para continuar
conda update conda
conda --version
conda install jupyter
conda install sqlite pandas openblas libxml2 numba numpy
# next step: configurar servidor jupyter para acesso remoto
# http://jupyter-notebook.readthedocs.org/en/latest/public_server.html

# Suporte Jupyter para outras linguagens
#https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

# Julia
# https://github.com/JuliaLang/IJulia.jl

# R
#http://irkernel.github.io/installation/
sudo yum -y install czmq-devel
R -e 'install.packages(c("rzmq","repr","IRkernel", "IRdisplay"), repos = c("http://irkernel.github.io/", "http://cran.fiocruz.br/", getOption("repos")), type = "source")'

# multi-user jupyter
# https://github.com/jupyter/jupyterhub

# Shell in a box
yum -y install pam-devel zlib-devel autoconf automake libtool # git openssl-devel

cd ~/tmp
git clone https://github.com/shellinabox/shellinabox.git && cd shellinabox
# Run autotools in project directory
autoreconf -i
# Run configure and make in project directory
./configure && make
make install
