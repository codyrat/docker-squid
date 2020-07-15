
FROM alpine

LABEL maintainer="Codyrat <codyrat@users.noreply.github.com>" \
  org.label-schema.name="Squid" \
  org.label-schema.description="AWS Squid docker image for proxy based on Alpine Linux." \
  org.label-schema.schema-version="1.0"


# HEALTHCHECK --interval=30m --timeout=1s \
#   CMD squidclient -h localhost cache_object://localhost/counters || exit 1

# Install packages
RUN echo "http://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --no-cache --update bash confd squid openssl 

# Redirect squid access logs to stdout
RUN ln -sf /dev/stdout /var/log/squid/access.log



# Copy confd configuration
COPY confd /etc/confd

# Set entrypoint and default command arguments
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["squid","-f","/etc/squid/squid.conf","-NYCd","1"]
