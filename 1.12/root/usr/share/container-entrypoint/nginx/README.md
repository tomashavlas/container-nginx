NGINX 1.12 http and reverse proxy server container image
========================================================

This container image includes NGINX http and reverse proxy server version 1.12 based on Debian.

The container image is available on [Docker Hub](https://hub.docker.com/r/tomashavlas/nginx) as
`tomashavlas/nginx:1.12-debian9`.


Description
-----------

[NGINX](https://www.nginx.com) is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server.

This container image provides containerized packaging of NGINX 1.12 daemon.
This image can be used as a base image for other applications based on NGINX 1.12, 
image can be extended using source-to-image(https://github.com/openshift/source-to-image) tool.


Usage
-----

This image can be used as a base image for other applications based on NGINX http and reverse proxy server.

This will create container named `nginx` running NGINX, serving data from `/wwwdata` directory.
Port `8080` will be exposed and mapped to the host.

```
$ docker run -d --name nginx -p 8080:8080 -v /wwwdata:/srv/www:Z tomashavlas/nginx:1.12-debian9
```

This will create new Docker layered image named `nginx-app`, using source-to-image, while using data available in `/wwwdata` on the host.

```
$ s2i build file:///wwwdata tomashavlas/nginx:1.12-debian9 nginx-app
```

To run new image, simply execute:

```
$ docker run -d --name nginx -p 8080:8080 nginx-app
```


S2I source repository layout
----------------------------

This image can be extended using source-to-image tool (see Usage section).

Application source code should be located in the root of the source directory.

**`./.nginx/conf.d`**

Should contain additional NGINX configuration files (`*.conf`), those will be copied into `/etc/nginx/conf.d`.

**`./.nginx/default.d`**

Should contain additional configuration files for default server block (`*.conf`), those will be copied into `/etc/nginx/default.d`.

**`./.nginx/pre-init.d`**

Should contain custom container initialization scripts, those will be copied into `/usr/share/container-entrypoint/nginx/pre-init.d`.


Environment variables
---------------------

This images recognizes the following environment variables that can be set during initialization by passing `-e VAR=VALUE` to the Docker run command.

**`NGINX_LOG_TO_VOLUME (default: 0)`**

If set to `1`, logs are stored in volume `/var/log/nginx`. Otherwise NGINX logs are redirected to `stdout` and `stderr`.


Volumes
-------

The following mount points can be set by passing `-v /host/path:/container/path` to the Docker run command.

**`/srv/www`**

NGINX server data directory.

**`/var/log/nginx`**

NGINX server log directory, used only when `NGINX_LOG_TO_VOLUME` is set to `1`.


Troubleshooting
---------------

The NGINX daemon in the container logs to the standard output by default, so the logs are available in container log.
The log can be examined by running:

```
$ docker logs <container>
```


See also
--------

Dockerfile and other sources for this container image are available on https://github.com/tomashavlas/container-nginx.
