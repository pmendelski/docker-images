# Squid Docker Container

[![Size and layers](https://images.microbadger.com/badges/image/mendlik/squid.svg)](https://microbadger.com/images/mendlik/squid)
[![Version](https://images.microbadger.com/badges/version/mendlik/squid.svg)](https://microbadger.com/images/mendlik/squid)
[![Commit](https://images.microbadger.com/badges/commit/mendlik/squid.svg)](https://microbadger.com/images/mendlik/squid)
[![Docker Stars](https://img.shields.io/docker/stars/mendlik/squid.svg?style=flat)](https://hub.docker.com/r/mendlik/squid/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mendlik/squid.svg?style=flat)](https://hub.docker.com/r/mendlik/squid/)

Run [squid](http://www.squid-cache.org/) caching proxy in a [docker](https://www.docker.com) container.

## Sample usage

Run squid with a [default configuration](/squid.conf).

```
docker run -p 3128:3128 mendlik/squid:latest
```

Run squid with a custom configuration and custom output directories.

```
docker run \
  -p 3128:3128 \
  -v $PWD/squid/squid.conf:/etc/squid/squid.conf \
  -v $PWD/squid/cache:/var/cache/squid \
  -v $PWD/squid/log:/var/log/squid \
  mendlik/squid:latest
```
