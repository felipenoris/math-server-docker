#!/bin/sh

# Run everythin as root user, using:
# sudo su

# For fresh CentOS, configure network
# dhclient eth0
# yum -y install system-config-network-tui

# For fresh Redhat6 on EC2
# the default EC2 user is: ec2-user

# yum -y install wget
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/main.sh
# chmod +x main.sh

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
chmod +x *sh
./toolchain_part1.sh > ~/out_part1.txt
./toolchain_part2.sh > ~/out_part2.txt
./toolchain_part3.sh > ~/out_part3.txt
./toolchain_part4.sh > ~/out_part4.txt
./toolchain_part5.sh > ~/out_part5.txt
./toolchain_part6.sh > ~/out_part6.txt
./toolchain_part7.sh > ~/out_part7.txt
#./toolchain_part8.sh > ~/out_part8.txt
./toolchain_part9.sh > ~/out_part9.txt
./toolchain_part10.sh > ~/out_part10.txt
