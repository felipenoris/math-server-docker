#!/bin/sh

sudo yum install -y wget
cd
mkdir tmp
cd tmp
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -ivh epel-release-6-8.noarch.rpm
sudo yum -y update

# Ferramentas para compilação
sudo yum -y install patch gcc-c++ gcc-gfortran bzip2 cmake curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

### GIT
# http://tecadmin.net/install-git-2-0-on-centos-rhel-fedora/#
cd /usr/local/src
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.6.4.tar.gz
sudo tar xzf git-2.6.4.tar.gz
cd git-2.6.4
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
#sudo echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile.d/git.sh
source /etc/bashrc
sudo rm /usr/local/src/git-2.6.4.tar.gz
###

### JULIA
cd ~/tmp
git clone https://github.com/JuliaLang/julia.git
cd julia
git checkout release-0.4
make
sudo make install
rm -rf julia

# para o R
cd ~/tmp
$ wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/lapack-devel-3.2.1-4.el6.x86_64.rpm'
$ wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/blas-devel-3.2.1-4.el6.x86_64.rpm'
$ wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/libicu-devel-4.2.1-9.1.el6_2.x86_64.rpm'
$ wget 'http://mirror.centos.org/centos/6/os/x86_64/Packages/texinfo-tex-4.13a-8.el6.x86_64.rpm'
$ wget 'ftp://rpmfind.net/linux/centos/6.6/os/x86_64/Packages/glpk-devel-4.40-1.1.el6.x86_64.rpm'
$ wget 'ftp://rpmfind.net/linux/centos/6.6/os/x86_64/Packages/glpk-4.40-1.1.el6.x86_64.rpm'
$ wget 'http://www.omegahat.org/XMLRPC/XMLRPC_0.3-0.tar.gz'
$ sudo yum localinstall lapack-devel-3.2.1-4.el6.x86_64.rpm
$ sudo yum localinstall blas-devel-3.2.1-4.el6.x86_64.rpm
$ sudo yum localinstall libicu-devel-4.2.1-9.1.el6_2.x86_64.rpm
$ sudo yum localinstall texinfo-tex-4.13a-8.el6.x86_64.rpm
$ sudo yum install unixodbc-devel
$ sudo yum install QuantLib
$ sudo yum install QuantLib-devel
$ sudo yum install boost
$ sudo yum install boost-devel
$ sudo yum install libxml2 libxml2-devel
$ sudo yum localinstall glpk
$ sudo yum localinstall glpk-devel
$ sudo yum install R

$ export CPATH=/usr/include/glpk

$ sudo R

> install.packages(c("data.table","XLConnect","RODBC","reshape","ggplot2","vars","sqldf","shinyAce"))
> install.packages("/tmp/XMLRPC_0.3-0.tar.gz", repos = NULL, type = "source")
> install.packages(c("iterators","RQuantLib","XML", "fArma", "fAsianOptions", "fBasics", "fBonds", "timeDate", "fExoticOptions", "fExtremes", "fGarch", "fImport", "fNonlinear", "fOptions", "timeSeries", "Hmisc","roxygen2","fPortfolio","relaimpo"))

O RStudio é uma interface web para a manipulação do R. Ele é instalado separadamente, e seu pacote está disponível aqui. De acordo com a documentação, a instalação do RStudio é realizada através dos seguintes passos:

$ sudo yum install openssl098e # Required only for RedHat/CentOS 6 and 7 $ wget http://download2.rstudio.org/rstudio-server-0.98.1087-x86_64.rpm
$ sudo yum install --nogpgcheck rstudio-server-0.98.1087-x86_64.rpm

Logo após a instalação, o RStudio já estará funcionando, porém, disponível na porta padrão 8787. Para facilitar o acesso, devemos alterar a porta para 80, default http, para facilitar o acesso pelos usuários:


$ sudo echo "www-port=80" > /etc/rstudio/rserver.conf $ sudo rstudio-server restart
$ sudo rstudio-server verify-installation

Importante: Veja que o processo do RStudio é configurado pelos arquivos contidos em /etc/rstudio (pasta padrão criada pela instalação do pacote), e gerenciado pelo comando rstudio-server.

VERIFICAR SE HÁ OUTRA ESTRATÉGIA (USAR ARQUIVO rsession.conf)

Feitas as instalações necessárias e configurado o RStudio para responder na porta 80, devemos configurá-lo para utilizar a autenticação integrada ao AD. Para isso, remetemos ao guia de administração do RStudio. Infelizmente, durante a instalação do ambiente de laboratório, identificamos que a documentação, em sua seção 5.3, indica a possibilidade de utilizar o parâmetro auth-pam-sessions-profile no arquivo de configuração do RStudio rserver.conf, sendo que o sistema não o reconhece como válido. Diante do cenário, o sistema foi monitorado e identificamos que as configurações do pam.d devem ser realizadas sobre o perfil /etc/pam.d /rstudio, incluindo-se neste as mesmas diretivas encontradas no perfil /etc/pam.d/su:

$ sudo cp -p /etc/rstudio/rserver.conf /etc/rstudio/rserver.conf.bak #faça um backup do arquivo de configuração do RStudio-server

$ sudo echo auth-pam-sessions-profile=rstudio-session >> /etc/rstudio/rserver.conf #inclua o parâmetro para um novo perfil do pam.d a ser utilizado

# inclua os parâmetros do novo perfil (próximas X linhas)

$ sudo echo auth sufficient pam_rootok.so >> /etc/pam.d/rstudio-session

Há, ainda pacotes adicionais necessários para a utilização do software de forma completa pela área demandante. As próximas seções explicam como instalá-los.

LibreOffice

O pacote (RPM) do LibreOffice precisa ser baixado do site da fundação, neste caminho. Uma fez feito o download, transfira o arquivo para o servidor em que se deseja instalar, descompacte o arquivo e instale o produto:

tar -xvf LibreOffice_4.3.3_Linux_x86-64_rpm.tar.gz cd LibreOffice_4.3.3.2_Linux_x86-64_rpm/

cd RPMS/
yum install *.rpm

O Shiny-server deve ser baixado do site do fornecedor, conforme instrui o documento. É necessário, no entanto, realizar a instalação do Package do Shiny no R antes de realizar a instalação do shiny-server. Os comandos abaixo permitem realizar estas operações:

$ sudo su - \

-c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

$ wget http://download3.rstudio.org/centos-5.9/x86_64/shiny-server-1.2.3.368-x86_64.rpm

$ sudo yum install --nogpgcheck shiny-server-1.2.3.368-x86_64.rpm

$ status shiny-server #confirme que o shiny-server está rodando. ex: shiny-server start/running, process 50862

$ sudo /opt/shiny-server/bin/deploy-example default #deploy da aplicação exemplo

Confirme o devido funcionamento do produto acessando http://<server-address>:3838/sample-apps/hello/. A página exibida deve ser semelhante a esta:

RMarkdown

Este package do R é instalado diretamente pela ferramenta, sendo necessário, entretanto, ter instalado o pacote libcurl-devel (equivalente, no RHEL, ao libcurl4-gnutls-dev do Ubuntu). Em seguida, deve proceder com os comandos de instalação do package:

$ sudo yum install libcurl-devel
$ sudo su -c "R -e \"install.packages('RCurl', repos='http://cran.rstudio.com/')\""
$ sudo su -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\"" $ sudo su -c "R -e \"devtools::install_github('hadley/devtools')\""
$ sudo su -c "R" #abrirá a linha de comando do R. Digite as 3 linhas abaixo devtools::install_github('rstudio/rmarkdown')
#Cran mirror: digitar 11
quit()
Save workspace image? [y/n/c]: y
$ sudo su -c "R -e \"devtools::install_github('rstudio/rmarkdown')\""
$ sudo yum install texlive #já deve estar instalado


