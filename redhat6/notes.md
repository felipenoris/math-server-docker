## Notes for Shellinabox

You may have to open port for external access

```shell
# /sbin/iptables -I INPUT -p tcp -m tcp --dport 4200 -j ACCEPT
# /sbin/service iptables save
```

You can start the service with a non-root user using the following command:

```shell
# shellinaboxd --css=/misc/white-on-black.css
```

Shellinabox will be accessible by default on the following link: `https://localhost:4200`

When using root user to start the service, it may not create the certificate automatically.

You can generate the certificate using the following commands:

```shell
# cd
# openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout certificate.pem -out certificate.pem -subj /CN=local/
# mv certificate.pem .ssh
# chmod 400 .ssh/certificate.pem
```

## Notes for Jupyter

To start the server:

```shell
# jupyterhub
```

To set IP and port, use:

```shell
# jupyterhub --ip=192.168.1.2 --port=443
```

Jupyterhub will be accessible by default on the following link: `http://localhost:8000`

You may have to open port for external access:

```shell
# /sbin/iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
# /sbin/service iptables save
```

Supported kernels for other languages: https://github.com/ipython/ipython/wiki/IPython-kernels-for-other-languages

## Notes for RStudio
Default port is 8787.

Change the default port by editing rserver.conf. The following will change to port 80:

```shell
# echo -e "www-port=80" | tee /etc/rstudio/rserver.conf
# rstudio-server restart
# rstudio-server verify-installation
```
