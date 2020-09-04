FROM quay.io/rbreslow/lua:5.1-alpine

ENV OPENRESTY_VERSION 1.17.8.2-r0
ENV OPENRESTY_KEY_URL "http://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub"
ENV LAPIS_VERSION 1.8.1-1

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN set -ex \
    && curl -o "/etc/apk/keys/$(basename ${OPENRESTY_KEY_URL})" "${OPENRESTY_KEY_URL}" \
    && apk add --no-cache \
        --repository "http://openresty.org/package/alpine/v3.12/main" \
        "openresty=${OPENRESTY_VERSION}" \
    && mkdir -p /var/run/openresty \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        lua5.1-dev \
        openssl \
        openssl-dev \
    && luarocks install lapis ${LAPIS_VERSION} \
    && apk del .build-deps curl unzip

ENTRYPOINT ["/usr/local/bin/lapis"]

CMD ["server"]
