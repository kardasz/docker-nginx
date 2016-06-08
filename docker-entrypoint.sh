#!/bin/bash
set -e

# first check if we're passing flags, if so
# prepend with nginx
if [ "${1:0:1}" = '-' ]; then
	set -- nginx "$@"
fi

if [ -z "$(getent passwd $NGINX_USER)" ]; then
  echo "Creating user $NGINX_USER:$NGINX_GROUP"

  groupadd --gid ${NGINX_GROUP_GID} -r ${NGINX_GROUP} && \
  useradd -r --uid ${NGINX_USER_UID} -g ${NGINX_GROUP} -d /var/www ${NGINX_USER}
fi

exec "$@"