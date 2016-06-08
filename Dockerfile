FROM debian:jessie

MAINTAINER Krzysztof Kardasz <krzysztof@kardasz.eu>

# Update system and install required packages
ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_USER            nginx
ENV NGINX_USER_UID        3535
ENV NGINX_GROUP           nginx
ENV NGINX_GROUP_GID       3535

RUN \
    groupadd --gid ${NGINX_GROUP_GID} -r ${NGINX_GROUP} && \
    useradd -r --uid ${NGINX_USER_UID} -g ${NGINX_GROUP} ${NGINX_USER}

RUN \
    apt-get update && \
    apt-get -y install apt-transport-https curl ca-certificates

RUN \
    curl http://nginx.org/keys/nginx_signing.key | apt-key add - && \
    echo "deb http://nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list && \
    apt-get update && \
    apt-get -y install nginx && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/www"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
