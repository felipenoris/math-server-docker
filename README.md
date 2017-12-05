
# math-server-docker

Dockerfile to build the ideal multi-user Data Science server with Jupyterhub and RStudio, ready for Python, R and Julia languages.

It's based on CentOS 7 image, which is a very stable Linux distribution, compatible with Red Hat (widely used in Corporations),
but often offers outdated packages. In order to provide up-to-date tools, this Dockerfile builds most tools from source.

## List of tools

* [Jupyterhub](https://github.com/jupyter/jupyterhub) with support for the following languages:

	* Python 2

	* Python 3

	* R

	* Julia 0.6

	* Scheme (provided by *Calysto Scheme* python package)

	* Bash

* [RStudio Server](https://www.rstudio.com/)

* [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server2/)

There's also a number of utilities under the hood:

* p7zip

* Java SDK

* memcached

* mongodb

* git

* svn

* sqlite3

* pigz

* node

* LaTeX (TeX Live)

* LibreOffice

* HDF5

* QuantLib

* [Gambit Scheme](http://gambitscheme.org)

* [uchardet](https://www.freedesktop.org/wiki/Software/uchardet/)

* [Go Language](https://golang.org/)

* [Gradle](https://gradle.org/)

## Usage

To build the image, run the following comand:

```
# docker build -t math-server .
```

Be patient. It may take up to 8 hours to complete.

After the build is complete, you can start the server with:

```
# docker run -d -p 8787:8787 -p 8000:8000 --name ms1 math-server
```

With a running container, you can go ahead and create users:

```
# docker exec ms1 useradd myuser
# docker exec -it ms1 passwd myuser
```

The default ports are:

* `8787` for RStudio

* `8000` for Jupyter

## Requirements

[Docker](https://www.docker.com/).

## Application specific notes

### Jupyter

Data files are at `/usr/local/share/jupyter/hub`.

To start the server:

```
# jupyterhub
```

By default, Jupyter will be accessible on the following link: `http://localhost:8000`, and will create state files (`jupyterhub_cookie_secret`, `jupyterhub.sqlite`) on current directory, and use default configuration.

You can generate a sample configuration file with:

```
# jupyterhub --generate-config
```

To start the server using a configuration file, use:

```
# jupyterhub -f jupyterhub_config.py
```

To set IP and port, use:

```
# jupyterhub --ip=192.168.1.2 --port=443
```

You may have to open port for external access:

```
# /sbin/iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
# /sbin/service iptables save
```

For `https` support, add the following lines to the config file:

```python
c.JupyterHub.port = 443
c.JupyterHub.ssl_cert = '/root/.ssh/sample-cert.pem'
c.JupyterHub.ssl_key = '/root/.ssh/sample-key.pem'
```

`443` is the default port for https. So the server will be accessible using https://localhost.

`sample-cert.pem` is the signed certificate file, and `sample-key.pem` is the private ssl key.

You can generate self signed certificate file by running the code below, but be aware that your browser will not recognize the certificate as trusted.

```
# mkdir ~/.ssh
# openssl req -x509 -newkey rsa:2048 -keyout ~/.ssh/sample-key.pem -out ~/.ssh/sample-cert.pem -days 9999 -nodes -subj "/C=BR/ST=Rio de Janeiro/L=Rio de Janeiro/O=org/OU=unit/CN=website"
# chmod 400 sample*.pem
```

This project provides a minimal `jupyter_config.py` configuration file that sets
a few important environment variables that should be passed to child spawned processes, namely: `'PATH', 'LD_LIBRARY_PATH', 'JAVA_HOME', 'CPATH', 'CMAKE_ROOT', 'http_proxy', 'https_proxy'`.

### RStudio

Configuration files are at `/etc/rstudio`. There's also the Server Options file at `/usr/lib/rstudio-server/R/ServerOptions.R`.

Default port is 8787.

Change the default port by editing `rserver.conf`. The following will change to port 80:

```
# echo -e "www-port=80" | tee /etc/rstudio/rserver.conf
# rstudio-server restart
# rstudio-server verify-installation
```

`auth-pam-sessions-profile` directive on /etc/rstudio.rserver.conf may not work. If that happens, RStudio will look at `/etc/pam.d/rstudio`.

Proxy settings are not configured in RStudio by default. If you're running behind proxy, you should update `ServerOptions.R` file.

```
RUN echo "options(download.file.method = 'wget')" >> /usr/lib/rstudio-server/R/ServerOptions.R
RUN echo "Sys.setenv(http_proxy = 'my-proxy-url')" >> /usr/lib/rstudio-server/R/ServerOptions.R
RUN echo "Sys.setenv(https_proxy = 'my-proxy-url')" >> /usr/lib/rstudio-server/R/ServerOptions.R
```

## Packages

**Python**

*root user* will add packages with `pip2` or `pip3` command line. Packages will be stored on `/usr/local/lib/python2.7` or `/usr/local/lib/python3.5` directories.

Users can install local packages using:

```
$ pip2 install --user pkgname

$ pip3 install --user pkgname
```

**R**

Check package locations with `$ R -e '.libPaths()'`.

System packages will be installed at `/usr/lib64/R/library`.

Each user can have a local package dir, automatically created under `~/R`.

*root user* will add packages with `R -e 'install.packages("pkg-name")'` command.

**Julia**

System packages will be installed to `/usr/local/julia/share/julia/site`.

Each user can add new search directories by changing Julia's `LOAD_PATH` variable.

```julia
julia> LOAD_PATH
2-element Array{ByteString,1}:
 "/usr/local/julia/local/share/julia/site/v0.5"
 "/usr/local/julia/share/julia/site/v0.5"
```

*root user* will add packages with `julia -e 'Pkg.add("pkg-name")'` command.

It's important to run `using pkg-name` after installation to precompile the packages. This will store files on `/usr/local/share/julia/lib/v0.4/`.

Users can install local packages using the default `Pkg` module:

```
julia> Pkg.add("pkgname")
```

**LaTeX**

The Docker image comes with a LaTeX distribution that is installed using [texlive](http://www.tug.org/texlive/) tool.
TeX packages can me managed using `tlmgr`.

System-wide packages can be installed using:

```
# tlmgr install [pkgname]
```

Users can also install local packages. To do that, a user must initialize a `~/texmf` tree:

```
$ tlmgr init-usertree
```

After that, the user can install local packages using:

```
$ tlmgr --usermode install [pkgname]
```

## References

* [Jupyter website](http://jupyter.org/)

* [Jupyterhub Docs](https://jupyterhub.readthedocs.org/en/latest/index.html)

* [Full list of supported kernels for Jupyter](https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages)

* [RStudio website](https://www.rstudio.com/)

* [RStudio Server download page](https://www.rstudio.com/products/rstudio/download-server/)

* [RStudio Server Admin Guide](https://s3.amazonaws.com/rstudio-server/rstudio-server-pro-0.99.879-admin-guide.pdf)

* [Shiny Server Admin Guide](http://rstudio.github.io/shiny-server/latest/)

* [Python](https://www.python.org/)

* [R](https://cran.r-project.org/)

* [Julia](http://julialang.org/)

* [Gambit Scheme](http://gambitscheme.org)
