#!/bin/sh

# Run everythin as root user, using:
# sudo su

# For fresh CentOS, configure network
# dhclient eth0
# yum -y install system-config-network-tui

# For fresh Redhat6 on EC2
# the default EC2 user is: ec2-user

# yum -y install wget
# cd
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/main.sh
# chmod u+x main.sh

yum -y install wget

cd
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part1.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part2.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part3.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part4.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part5.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part6.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part7.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part8.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part9.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/toolchain_part10.sh
wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/final_check.sh

source ~/toolchain_part1.sh > ~/out_part1.txt 2>&1
source ~/toolchain_part2.sh > ~/out_part2.txt 2>&1
source ~/toolchain_part3.sh > ~/out_part3.txt 2>&1
source ~/toolchain_part4.sh > ~/out_part4.txt 2>&1
source ~/toolchain_part5.sh > ~/out_part5.txt 2>&1
source ~/toolchain_part6.sh > ~/out_part6.txt 2>&1
source ~/toolchain_part7.sh > ~/out_part7.txt 2>&1
source ~/toolchain_part8.sh > ~/out_part8.txt 2>&1
source ~/toolchain_part9.sh > ~/out_part9.txt 2>&1
source ~/toolchain_part10.sh > ~/out_part10.txt 2>&1
source ~/final_check.sh > ~/final_check.txt 2>&1
