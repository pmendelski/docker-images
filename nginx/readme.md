# Docker image with nginx

[![Size and layers](https://images.microbadger.com/badges/image/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Version](https://images.microbadger.com/badges/version/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Commit](https://images.microbadger.com/badges/commit/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/mendlik/nginx.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mendlik/nginx.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx/)

A [Docker](docker) image with [Nginx](nginx).

## Inside the image

- [Alpine Linux][alpinelinux] - a lightweight Linux distribution
- [Nginx][nginx] - a web server and load balancer

## Simple usage

```
docker run --name nginx \
  -p 80:80 -p 443:443 \
  -v $PWD/nginx.conf:/etc/nginx/nginx.conf \
  -v $PWD/log:/var/log/nginx \
  mendlik/nginx
```

[alpinelinux]: https://www.alpinelinux.org/
[apache]: https://httpd.apache.org/
[docker]: https://www.docker.com/
[nginx]: https://www.nginx.com/
