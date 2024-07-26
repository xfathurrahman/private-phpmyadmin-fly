FROM phpmyadmin:fpm-alpine

ARG TSVERSION=1.70.0
ARG TSFILE=tailscale_${TSVERSION}_amd64.tgz

WORKDIR /var/www/html

COPY /nginx/nginx.conf /etc/nginx/nginx.conf
COPY /pma/config.secret.inc.php /etc/phpmyadmin/config.secret.inc.php
COPY /entrypoint.sh /entrypoint.sh

RUN apk add --no-cache tar ca-certificates openssl tzdata iptables ip6tables iputils-ping nginx \
    && wget https://pkgs.tailscale.com/stable/${TSFILE} \
    && tar xzf ${TSFILE} --strip-components=1 \
    && mv tailscaled /usr/local/bin/tailscaled \
    && mv tailscale /usr/local/bin/tailscale \
    && rm -rf ${TSFILE} \
    && apk del tar \
    && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/entrypoint.sh" ]
USER root
