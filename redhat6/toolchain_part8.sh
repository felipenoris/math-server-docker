#!/bin/sh

###########################
## APPS
###########################

# R Packages
cd ~/tmp

R -e 'install.packages(c("RCurl", "XML"))'

#XMLRPC
wget 'http://bioconductor.org/packages/devel/extra/src/contrib/XMLRPC_0.3-0.tar.gz'
R -e 'install.packages("XMLRPC_0.3-0.tar.gz", repos = NULL, type = "source")'
rm -f XMLRPC_0.3-0.tar.gz

R -e 'install.packages(c("data.table","XLConnect","reshape","ggplot2","vars","sqldf","shinyAce"))' # RODBC
R -e 'install.packages(c("iterators","RQuantLib","fArma", "fAsianOptions", "fBasics", "fBonds", "timeDate", "fExoticOptions", "fExtremes", "fGarch", "fImport", "fNonlinear", "fOptions", "timeSeries", "Hmisc","roxygen2","fPortfolio","relaimpo"))' #Rsymphony, RQuantLib, Rglpk, fPortfolio
R -e 'install.packages(c("plyr","gmp","Rmpfr","doParallel","foreach","DEoptim","pbivnorm","cubature"))'

# RStudio
yum -y install openssl098e # Required only for RedHat/CentOS 6 and 7
cd ~/tmp
wget https://download2.rstudio.org/rstudio-server-rhel-0.99.879-x86_64.rpm

echo "7a641c79a49bf60ea70a2c3244bdf074  rstudio-server-rhel-0.99.879-x86_64.rpm" > RSTUDIOMD5
RESULT=$(md5sum -c RSTUDIOMD5)
echo ${RESULT} > ~/check-rstudio-md5.txt
yum -y install --nogpgcheck rstudio-server-rhel-0.99.879-x86_64.rpm
rm -f rstudio-server-rhel-0.99.879-x86_64.rpm

# Default port is 8787.
# echo -e "www-port=80" | tee /etc/rstudio/rserver.conf
rstudio-server restart
rstudio-server verify-installation

# https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server
# https://support.rstudio.com/hc/en-us/articles/200488488-Configuring-R-to-Use-an-HTTP-or-HTTPS-Proxy
# https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy
# http://www.r-bloggers.com/how-to-get-your-very-own-rstudio-server-and-shiny-server-with-digitalocean/
# https://s3.amazonaws.com/rstudio-server/rstudio-server-pro-0.99.879-admin-guide.pdf

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

# lastest version for CentOS6 is:
# wget http://download3.rstudio.org/centos6.3/x86_64/shiny-server-1.5.0.730-rh6-x86_64.rpm

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
