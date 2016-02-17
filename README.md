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
# chmod +x main.sh
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

- [ ] build Julia with system's llvm and shared libs.

- [ ] add https support for Jupyter.

- [ ] fix user authentication on Jupyter.

- [ ] complete RStudio installation.

- [ ] install Shiny for RStudio.

- [ ] Solve packages folder issue for python, julia and R.

- [ ] Define user groups.

- [ ] Precompilated packages default to /usr/local/share/julia/lib. This should be a per-user configuration. Current workaround: use a regular user to precompile packages.

- [ ] Error with jupyterhub with Julia kernel. Compat not found in path.

```
[I 2016-02-11 03:24:06.973 felipenoris restarter:103] KernelRestarter: restarting kernel (4/5)
WARNING:root:kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 restarted
ERROR: LoadError: LoadError: ArgumentError: Compat not found in path
 in require at ./loading.jl:233
 in include at ./boot.jl:261
 in include_from_node1 at ./loading.jl:304
 in include at ./boot.jl:261
 in include_from_node1 at ./loading.jl:304
 in process_options at ./client.jl:280
 in _start at ./client.jl:378
while loading /usr/local/share/julia/v0.4/IJulia/src/IJulia.jl, in expression starting on line 4
while loading /usr/local/share/julia/v0.4/IJulia/src/kernel.jl, in expression starting on line 4
[W 2016-02-11 03:24:09.988 felipenoris restarter:95] KernelRestarter: restart failed
[W 2016-02-11 03:24:09.988 felipenoris kernelmanager:54] Kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 died, removing from map.
ERROR:root:kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 restarted failed!
[W 2016-02-11 03:24:10.001 felipenoris handlers:463] Kernel deleted before session
[W 2016-02-11 03:24:10.001 felipenoris log:47] 410 DELETE /user/felipenoris/api/sessions/ac31537a-1ede-4eff-8ff0-42d6c58ad6ee (::ffff:192.168.56.1) 1.48ms referer=http://192.168.56.101:8000/user/felipenoris/notebooks/Untitled5.ipynb?kernel_name=julia-0.4
```
