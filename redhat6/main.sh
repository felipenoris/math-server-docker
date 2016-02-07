#!/bin/sh

# Run everythin as root user, using:
# sudo su

# For fresh CentOS, configure network
# dhclient eth0
# yum -y install system-config-network-tui

# For fresh Redhat6 on EC2
# the default EC2 user is: ec2-user

yum -y install wget

echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
source ~/.bashrc
cd
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part1.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part2.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part3.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part4.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part5.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part6.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part7.sh
chmod +x *sh
./toolchain_part1.sh
./toolchain_part2.sh
./toolchain_part3.sh
./toolchain_part4.sh
./toolchain_part5.sh
./toolchain_part6.sh
./toolchain_part7.sh
