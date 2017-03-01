# Docker image with nginx

[![Size and layers](https://images.microbadger.com/badges/image/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Version](https://images.microbadger.com/badges/version/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Commit](https://images.microbadger.com/badges/commit/mendlik/nginx.svg)](https://microbadger.com/images/mendlik/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/mendlik/nginx.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mendlik/nginx.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx/)

A [Docker](docker) image with [Nginx](nginx) configured to act as a caching proxy for HTTP requests.

## Inside the image

- [Alpine Linux][alpinelinux] - a lightweight Linux distribution
- [Nginx][nginx] - a web caching proxy

## Simple usage

```
docker run --name nginx-cache \
  -p 80:80 \
  -v $PWD/log:/var/log/nginx \
  -v $PWD/cache:/var/cache/nginx \
  mendlik/nginx-cache
```

## Test case

1. Start image
2. Send HTTP request. Example: `curl 'http://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.min.js'`
3. Send the same HTTP request.
4. Second request is cached and have HTTP header:

[alpinelinux]: https://www.alpinelinux.org/
[apache]: https://httpd.apache.org/
[docker]: https://www.docker.com/
[nginx]: https://www.nginx.com/
