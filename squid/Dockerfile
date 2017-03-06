FROM alpine:3.5

ENV SQUID_VERSION=${SQUID_VERSION:-3.5.23-r0}

RUN apk --no-cache add \
  squid=$SQUID_VERSION

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3128
CMD ["squid"]
