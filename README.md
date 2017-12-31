NGINX http and reverse proxy server container image
===================================================

[![Build Stauts](https://api.travis-ci.org/tomashavlas/container-nginx.svg?branch=master)](https://travis-ci.org/tomashavlas/container-nginx/)

This repository contains Dockerfiles and scripts for NGINX container images based on Debian.


Versions
--------

NGINX versions provided:

* [NGINX 1.12](1.12)

Debian versions supported:

* Debian 9 "Stretch"


Installation
------------

* **Debain 9 based image**

    This image is available on DockerHub. To download it run:
    
    ```
    $ docker pull tomashavlas/nginx:1.12-debian9
    ```
    
    To build latest Debian based NGINX image from source run:
    
    ```
    $ git clone --recursive https://github.com/tomashavlas/container-nginx
    $ cd container-nginx
    $ git submodule update --init
    $ make build TARGET=debian9 VERSION=1.12
    ```
    
To build other version of NGINX just replace `1.12` value by particular version in commands above.

    
Usage
-----

For information about usage of Dockerfile for NGINX 1.12 see [usage documentation](1.12).


Test
----

This repository also provides a test framework, which checks basic functionality of NGINX image.

* **Debain 9 based image**

    ```
    $ cd container-nginx
    $ make test TARGET=debian9 VERSION=1.12
    ```


Credits
-------

This project is derived from [`nginx-container`](https://github.com/sclorg/nginx-container) by
[SoftwareCollections.org](https://www.softwarecollections.org).
