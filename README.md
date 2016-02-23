# AWSFinance

Toolchain script for Financial and Mathematical Programming on Amazon´s AWS EC2 fresh instance.

## List of tools

* Jupyterhub [https://github.com/jupyter/jupyterhub] with support for the following languages:

	* Python 2.7

	* Python 3.5

	* R 3.2.3

	* Julia 0.4

* RStudio Server [https://www.rstudio.com/]

## Usage

1 - Start a fresh server instance with a minimal installation of *redhat6* or *centos6*.

2 - Access your system as root.

```shell
$ sudo su
```

3 - Install wget.

```
# yum -y install wget
```

4 - Download and run the main script.

```
# cd
# wget https://raw.githubusercontent.com/felipenoris/AWSFinance/master/redhat6/main.sh
# chmod u+x main.sh
# ./main.sh 
```

## Requirements

*Redhat6* or *CentOS6*.

## System specific notes

### CentOS6

For a fresh *CentOS6* Virtual Machine, you may need to configure network:

```
# dhclient eth0
# yum -y install system-config-network-tui
```

### Redhat6

For a fresh *Redhat6* instance on Amazon's EC2, the default user is `ec2-user`.

## Application specific notes

### Jupyter

To start the server:

```
# jupyterhub
```

By default, Jupyterhub will be accessible on the following link: `http://localhost:8000`.

To set IP and port, use:

```
# jupyterhub --ip=192.168.1.2 --port=443
```

You may have to open port for external access:

```
# /sbin/iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
# /sbin/service iptables save
```

The full list of supported kernels is at https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages.

### RStudio

Default port is 8787.

Change the default port by editing rserver.conf. The following will change to port 80:

```
# echo -e "www-port=80" | tee /etc/rstudio/rserver.conf
# rstudio-server restart
# rstudio-server verify-installation
```

## TODO list

- [ ] redhat7 toolchain script is under construction.

- [ ] add https support for Jupyter.

- [ ] complete RStudio installation.

- [ ] install Shiny for RStudio.

- [ ] Solve packages folder issue for python, julia and R.

- [ ] Define user groups.

- [ ] Precompilated packages default to /usr/local/share/julia/lib. This should be a per-user configuration. Current workaround: use a regular user to precompile packages.

## References

* Jupyter main website: http://jupyter.org/

* Jupyterhub Docs: https://jupyterhub.readthedocs.org/en/latest/index.html

* RStudio website: https://www.rstudio.com/