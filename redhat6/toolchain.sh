#!/bin/sh

#dhclient eth0
#yum -y install system-config-network-tui

sudo yum install -y wget
mkdir ~/tmp
cd ~/tmp
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain.sh
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -ivh epel-release-6-8.noarch.rpm
sudo yum -y update
rm epel-release-6-8.noarch.rpm

# Ferramentas para compilação
sudo yum -y install patch gcc-c++ gcc-gfortran bzip2 cmake curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

# para o R
cd ~/tmp
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/lapack-devel-3.2.1-4.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/blas-devel-3.2.1-4.el6.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/libicu-devel-4.2.1-9.1.el6_2.x86_64.rpm'
wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/texinfo-tex-4.13a-8.el6.x86_64.rpm'
wget 'ftp://rpmfind.net/linux/centos/6.6/os/x86_64/Packages/glpk-devel-4.40-1.1.el6.x86_64.rpm'
wget 'ftp://rpmfind.net/linux/centos/6.6/os/x86_64/Packages/glpk-4.40-1.1.el6.x86_64.rpm'
sudo yum -y localinstall lapack-devel-3.2.1-4.el6.x86_64.rpm
sudo yum -y localinstall blas-devel-3.2.1-4.el6.x86_64.rpm
sudo yum -y localinstall libicu-devel-4.2.1-9.1.el6_2.x86_64.rpm
sudo yum -y localinstall texinfo-tex-4.13a-8.el6.x86_64.rpm
sudo yum -y install unixodbc-devel
sudo yum -y install QuantLib
sudo yum -y install QuantLib-devel
sudo yum -y install boost
sudo yum -y install boost-devel
sudo yum -y install libxml2 libxml2-devel
sudo yum -y localinstall glpk
sudo yum -y localinstall glpk-devel
sudo yum -y install R

export CPATH=/usr/include/glpk

#$ sudo R

#$ wget 'http://www.omegahat.org/XMLRPC/XMLRPC_0.3-0.tar.gz'
#> install.packages("/tmp/XMLRPC_0.3-0.tar.gz", repos = NULL, type = "source")

#> install.packages(c("data.table","XLConnect","RODBC","reshape","ggplot2","vars","sqldf","shinyAce"))
#> install.packages(c("iterators","RQuantLib","XML", "fArma", "fAsianOptions", "fBasics", "fBonds", "timeDate", "fExoticOptions", "fExtremes", "fGarch", "fImport", "fNonlinear", "fOptions", "timeSeries", "Hmisc","roxygen2","fPortfolio","relaimpo"))

# RStudio
sudo yum -y install openssl098e # Required only for RedHat/CentOS 6 and 7
cd ~/tmp
wget https://download2.rstudio.org/rstudio-server-rhel-0.99.489-x86_64.rpm
sudo yum -y install --nogpgcheck rstudio-server-rhel-0.99.489-x86_64.rpm

# Default port is 8787. Changing to port 80 (default for http).

echo -e "www-port=80" | sudo tee /etc/rstudio/rserver.conf
sudo rstudio-server restart
sudo rstudio-server verify-installation

#Importante: Veja que o processo do RStudio é configurado pelos arquivos contidos em /etc/rstudio (pasta padrão criada pela instalação do pacote), e gerenciado pelo comando rstudio-server.

#VERIFICAR SE HÁ OUTRA ESTRATÉGIA (USAR ARQUIVO rsession.conf)

#Feitas as instalações necessárias e configurado o RStudio para responder na porta 80, devemos configurá-lo para utilizar a autenticação integrada ao AD. Para isso, remetemos ao guia de administração do RStudio. Infelizmente, durante a instalação do ambiente de laboratório, identificamos que a documentação, em sua seção 5.3, indica a possibilidade de utilizar o parâmetro auth-pam-sessions-profile no arquivo de configuração do RStudio rserver.conf, sendo que o sistema não o reconhece como válido. Diante do cenário, o sistema foi monitorado e identificamos que as configurações do pam.d devem ser realizadas sobre o perfil /etc/pam.d /rstudio, incluindo-se neste as mesmas diretivas encontradas no perfil /etc/pam.d/su:

sudo cp -p /etc/rstudio/rserver.conf /etc/rstudio/rserver.conf.bak #faça um backup do arquivo de configuração do RStudio-server
#$ sudo echo auth-pam-sessions-profile=rstudio-session >> /etc/rstudio/rserver.conf #inclua o parâmetro para um novo perfil do pam.d a ser utilizado

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
sudo make install

# new gcc
# CentOS6 vem com versão antiga do GCC.
# Para compilar o julia, é necessário instalar uma versão mais recente
# https://www.vultr.com/docs/how-to-install-gcc-on-centos-6
# https://gcc.gnu.org/install/build.html
cd ~/tmp
sudo yum -y install svn texinfo-tex flex zip libgcc.i686 glibc-devel.i686
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_5_3_0_release/
cd gcc_5_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_build
cd gcc_build
../gcc_5_3_0_release/configure
make -j 8 # incluir número de cores para compilação em paralelo, ver resultado de nproc
sudo make install
hash -r # forget about old gcc
gcc --version
g++ --version
which gcc
# Add new libraries to linker
echo "/usr/local/lib64" > usrLocalLib64.conf
sudo mv usrLocalLib64.conf /etc/ld.so.conf.d/
sudo ldconfig

### GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
cd /usr/local/src
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
sudo tar xzf git-2.6.4.tar.gz
cd git-2.6.4
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
sudo rm /usr/local/src/git-2.6.4.tar.gz
###
cd ~/tmp
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
sudo tar xzf git-2.6.4.tar.gz
cd git-2.6.4
make all
sudo make install
sudo rm ~/tmp/git-2.6.4.tar.gz
###

### JULIA
cd ~/tmp
git clone https://github.com/JuliaLang/julia.git
cd julia
git checkout release-0.4
make
sudo make install
rm -rf julia

# misc stuff
sudo yum -y install clang # checar versao...
sudo yum -y install valgrind # checar versao...

