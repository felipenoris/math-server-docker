Versão do AWS Amazon: Red Hat Enterprise Linux 7.1

# YUM
yum check-update
yum update packagename
yum update
yum install packagename

# sudo

/etc/sudoers configura usuários que podem dar sudo utilizando o próprio password.
para editar o arquivo: usar comando visudo

exemplo de linha do sudoers no caso de acesso completo:
juan ALL=(ALL) ALL

https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Gaining_Privileges-The_sudo_Command.html

# User admin
/etc/skel/ contém os arquivos user settings default (.bashrc, etc.)

# logando numa instância fresh do Red Hat amazon
$ ssh -i .ssh/key.pem ec2-user@ip

## default user name at amazon is **ec2-user**
