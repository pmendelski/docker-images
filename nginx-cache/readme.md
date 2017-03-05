# Docker image with nginx

[![Size and layers](https://images.microbadger.com/badges/image/mendlik/nginx-cache.svg)](https://microbadger.com/images/mendlik/nginx-cache)
[![Version](https://images.microbadger.com/badges/version/mendlik/nginx-cache.svg)](https://microbadger.com/images/mendlik/nginx-cache)
[![Commit](https://images.microbadger.com/badges/commit/mendlik/nginx-cache.svg)](https://microbadger.com/images/mendlik/nginx-cache)
[![Docker Stars](https://img.shields.io/docker/stars/mendlik/nginx-cache.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx-cache/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mendlik/nginx-cache.svg?style=flat)](https://hub.docker.com/r/mendlik/nginx-cache/)

A [Docker](docker) image with [Nginx](nginx) configured to act as a long caching proxy for HTTP requests.

I use it while performing programming presentations with life coding sessions. It is especially useful when you do some frontend coding and have CDN dependencies in your HTML.

## Inside the image

- [Alpine Linux][alpinelinux] - a lightweight Linux distribution
- [Nginx][nginx] - a web caching proxy

## Simple usage

1. Start the container
```
docker run -d --name nginx-long-cache \
  -p 8787:8080 \
  -v $HOME/.nginx/longcache/log:/var/log/nginx \
  -v $HOME/.nginx/longcache/cache:/var/cache/nginx \
  mendlik/nginx-cache
```
2. Setup system wide network proxy for HTTP ([Example for Ubuntu](https://help.ubuntu.com/stable/ubuntu-help/net-proxy.html))

## Test case

1. Start the container
2. Send twice the same HTTP request through the caching proxy.
```
curl -I -x 'localhost:8787' 'http://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.min.js'
```
4. Second request is cached and contains following headers:
```
X-Cached: HIT
X-Cache-Server: mendlik/nginx-cache
```

[alpinelinux]: https://www.alpinelinux.org/
[apache]: https://httpd.apache.org/
[docker]: https://www.docker.com/
[nginx]: https://www.nginx.com/
