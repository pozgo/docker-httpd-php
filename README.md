# Apache winth PHP-FPM in a Docker with Supervisor (CentOS 7)

[![Build Status](https://travis-ci.org/pozgo/docker-httpd-php.svg)](https://travis-ci.org/pozgo/docker-httpd-php)  
[![GitHub Open Issues](https://img.shields.io/github/issues/pozgo/docker-httpd-php.svg)](https://github.com/pozgo/docker-httpd-php/issues)  
[![Stars](https://img.shields.io/github/stars/pozgo/docker-httpd-php.svg?style=social&label=Stars)]()
[![Fork](https://img.shields.io/github/forks/pozgo/docker-httpd-php.svg?style=social&label=Fork)]()  
[![Docker Start](https://img.shields.io/docker/stars/polinux/httpd-php.svg)](https://hub.docker.com/r/polinux/httpd-php)
[![Docker Pulls](https://img.shields.io/docker/pulls/polinux/httpd-php.svg)](https://hub.docker.com/r/polinux/httpd-php)
[![Docker Auto](https://img.shields.io/docker/automated/polinux/httpd-php.svg)](https://hub.docker.com/r/polinux/httpd-php)  
[![](https://img.shields.io/github/release/pozgo/docker-httpd-php.svg)](http://microbadger.com/images/polinux/httpd-php)


Felling like supporting me in my projects use donate button. Thank You!  
[![](https://img.shields.io/badge/donate-PayPal-blue.svg)](https://www.paypal.me/POzgo)

This is [Docker Image](https://registry.hub.docker.com/u/polinux/httpd-php/) with Apache + PHP-FPM combo using [polinux/supervisor](https://hub.docker.com/r/polinux/supervisor) docker image as base.

For different PHP versions, look up different branches of this repository.
On Docker Hub you can find them under different tags:

|PHP Version|Image Name| Branch |Status|
|:-:|:--|:--|:-:|
|7.2|`polinux/httpd-php:php72`|php-7.2|[![Build Status](https://travis-ci.org/pozgo/docker-httpd-php.svg?branch=php-7.2)](https://travis-ci.org/pozgo/docker-httpd-php)|
|7.1|`polinux/httpd-php:php71`|php-7.1|[![Build Status](https://travis-ci.org/pozgo/docker-httpd-php.svg?branch=php-7.1)](https://travis-ci.org/pozgo/docker-httpd-php)|
|7.0|`polinux/httpd-php:php70`|php-7.0|[![Build Status](https://travis-ci.org/pozgo/docker-httpd-php.svg?branch=php-7.0)](https://travis-ci.org/pozgo/docker-httpd-php)|
|5.6|`polinux/httpd-php:php56`|php-5.6|[![Build Status](https://travis-ci.org/pozgo/docker-httpd-php.svg?branch=php-5.6)](https://travis-ci.org/pozgo/docker-httpd-php)|

**This image have `inotify` installed and set to gracefuly reload when Apache config changes, including VHosts.**

Default web directory is set to `/var/www/html/`.
`info.php` is present in this image. just got to `http://localhost/info.php`

Multiple versions of php can be selected from tags in Docker Hub. 


### Common dev tools for web app development

- Ruby 2.0, Bundler
- NodeJS and NPM
- NPM packages like `gulp`, `grunt`, `bower`, `browser-sync`

### Packages installed (PHP mods)

- `php-fpm`  
- `php-gd`  
- `php-mbstring`  
- `php-mcrypt`  
- `php-pdo`  
- `ImageMagick`  
- `GraphicsMagick`  
- `gulp`  
- `grunt-cli`  
- `bower`  
- `browser-sync`  
- `node`  
- `ruby`  
- `bundler`  
- `memcached`  
- `redis`  
- `git`

### Environmental Variable (From polinux/httpd image)

|Variable|DefaultSettings|Info|
|:--|:--|:--|
|`LOG_LEVEL`|`info`|Specify log level Apache should when started. [Apache Log Levels](https://httpd.apache.org/docs/2.4/mod/core.html#loglevel)|
|`DEFAULT_CONFIG`|`true`|Use default config provided by Apache package - Change to `false` when using custom config|

### Usage

#### Basic

    docker run \
      -d \
      --name httpd-php \
      -p 80:80 \
      polinux/httpd-php

#### Set log level to debug and php 7.1

    docker run \
      -d \
      --name httpd-php \
      -p 80:80 \
      -e LOG_LEVEL="debug" \
      polinux/httpd-php:php71

### Build

    docker build -t polinux/httpd-php .

Docker troubleshooting
======================

Use docker command to see if all required containers are up and running:
```
$ docker ps
```

Check logs of httpd-php server container:
```
$ docker logs httpd-php
```

Sometimes you might just want to review how things are deployed inside a running
 container, you can do this by executing a _bash shell_ through _docker's
 exec_ command:
```
docker exec -ti httpd-php /bin/bash
```

History of an image and size of layers:
```
docker history --no-trunc=true polinux/httpd-php | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'
```

## Author

Przemyslaw Ozgo (<linux@ozgo.info>)