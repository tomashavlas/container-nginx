FROM debian:stretch-slim

EXPOSE 8080 \
       8443

ENV NGINX_VERSION=1.12 \
    NGINX_RELEASE=1.12.2 \
    NGINX_CHECKSUM=305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416 \
    NGINX_SOURCE=/usr/src/nginx \
    NGINX_TARBALL=/usr/src/nginx-1.12.2.tar.gz \
    HOME=/srv/www

LABEL name="tomashavlas/nginx" \
      version="${NGINX_VERSION}" \
      release="${NGINX_RELEASE}" \
      maintaner="Tomáš Havlas <tomas@havlas.me>" \
      vendor="Tomáš Havlas" \
      io.openshift.s2i.scripts-url=image:///usr/lib/s2i

ENV NGINX_CONF_PATH=/etc/nginx \
    NGINX_CONFD_PATH=/etc/nginx/conf.d \
    NGINX_DEFAULTD_PATH=/etc/nginx/default.d \
    NGINX_LIB_PATH=/var/lib/nginx \
    NGINX_LOCK_PATH=/var/lock/nginx \
    NGINX_LOG_PATH=/var/log/nginx \
    NGINX_RUN_PATH=/run/nginx \
    NGINX_SNIPPETD_PATH=/etc/nginx/snippet.d

RUN useradd --home-dir /usr/share/nginx --gid 0 --shell /usr/sbin/nologin --system --uid 48 nginx \
 \
 && apt-get update \
 && BUILD_DEPS=" \
        gcc \
        libpcre++-dev \
        libssl1.0-dev \
        make \
        zlib1g-dev " \
 && RUNTIME_DEPS=" \
        gettext-base \
        libnss-wrapper \
        libpcre++0v5 \
        libssl1.0.2 \
        zlib1g " \
 && apt-get install --yes --no-install-recommends --verbose-versions ${BUILD_DEPS} ${RUNTIME_DEPS} \
 \
 && rm --recursive /var/lib/apt/lists/*

RUN apt-get update \
 && BUILD_DEPS=" \
        ca-certificates \
        wget " \
 && apt-get install --yes --no-install-recommends --verbose-versions ${BUILD_DEPS} \
 \
 && wget -O "${NGINX_TARBALL}" "https://nginx.org/download/nginx-1.12.2.tar.gz" \
 && echo "${NGINX_CHECKSUM} *${NGINX_TARBALL}" | sha256sum --check - \
 \
 && apt-get purge --yes --auto-remove ${BUILD_DEPS} \
 && rm --recursive /var/lib/apt/lists/*

COPY [ "./root/usr/bin/docker-nginx-*", "/usr/bin/" ]

RUN docker-nginx-source extract \
 && docker-nginx-install \
        --with-http_realip_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-ipv6 \
 && docker-nginx-source delete

ENV CONTAINER_ENTRYPOINT_PATH=/usr/share/container-entrypoint \
    CONTAINER_PASSWD_PATH="${NGINX_CONF_PATH}/passwd" \
    S2I_BIN_PATH=/usr/lib/s2i

COPY [ "./s2i/bin", "${S2I_BIN_PATH}/" ]
COPY [ "./common/root", "./root", "./${NGINX_VERSION}/root", "/" ]
RUN /usr/lib/container-entrypoint/nginx-setup \
 && test "$( id nginx )" = "uid=48(nginx) gid=0(root) groups=0(root)"

VOLUME [ "${NGINX_LOG_PATH}" ]

USER 48

WORKDIR "${HOME}"
ENTRYPOINT [ "container-entrypoint" ]
CMD [ "/usr/lib/s2i/usage" ]
