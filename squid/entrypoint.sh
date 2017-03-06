#!/bin/sh
set -e

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

if [[ -z ${1} ]]; then
  echo "Starting squid"
  mkdir -p /var/cache/squid
  chown -R squid:squid /var/cache/squid
  mkdir -p /var/log/squid
  chown -R squid:squid /var/log/squid
  if [[ ! -d /var/cache/squid/00 ]]; then
    echo "Initializing squid cache..."
    /usr/sbin/squid -Nz
    echo "Squid cache initialized"
  fi
  exec /usr/sbin/squid -NYd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
