
###########################
## APPS
###########################

yum -y install libcurl libcurl-devel

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

rstudio-server restart
rstudio-server verify-installation

# https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server
# https://support.rstudio.com/hc/en-us/articles/200488488-Configuring-R-to-Use-an-HTTP-or-HTTPS-Proxy
# https://support.rstudio.com/hc/en-us/articles/200552326-Running-with-a-Proxy
# http://www.r-bloggers.com/how-to-get-your-very-own-rstudio-server-and-shiny-server-with-digitalocean/
# https://s3.amazonaws.com/rstudio-server/rstudio-server-pro-0.99.879-admin-guide.pdf

# Auth
# auth-pam-sessions-profile directive on /etc/rstudio.rserver.conf may not work.
# If that happens, RStudio will look at /etc/pam.d/rstudio

# sudo echo auth sufficient pam_rootok.so >> /etc/pam.d/rstudio-session

#LibreOffice
cd
wget http://tdf.c3sl.ufpr.br/libreoffice/stable/5.0.5/rpm/x86_64/LibreOffice_5.0.5_Linux_x86-64_rpm.tar.gz

echo "1e80150b20d85e930f9471926ed58599  LibreOffice_5.0.5_Linux_x86-64_rpm.tar.gz" > LIBREOFFICEMD5
RESULT=$(md5sum -c LIBREOFFICEMD5)
echo ${RESULT} > ~/check-libreoffice-md5.txt

tar xf LibreOffice_5.0.5_Linux_x86-64_rpm.tar.gz
cd LibreOffice_5.0.5.2_Linux_x86-64_rpm/RPMS
yum -y install *.rpm

# Shiny
R -e 'install.packages("shiny")'
cd
wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.1.759-rh5-x86_64.rpm
echo "f229d1eda060e7317245512a2013602a  shiny-server-1.4.1.759-rh5-x86_64.rpm" > SHINYSERVERMD5
RESULT=$(md5sum -c SHINYSERVERMD5)
echo ${RESULT} > ~/check-shiny-server-md5.txt
yum -y install --nogpgcheck shiny-server-1.4.1.759-rh5-x86_64.rpm

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
