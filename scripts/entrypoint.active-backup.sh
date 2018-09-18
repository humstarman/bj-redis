#!/bin/bash
set -ex
THIS_IP=${POD_IP}
REDIS_CONF=/usr/local/etc/redis/redis.conf
sed -i "s/{{.ip}}/${THIS_IP}/g" ${REDIS_CONF}
sed -i "s/# maxmemory <bytes>/maxmemory $[25*1024*1024*1024]/g" ${REDIS_CONF}
if [ "$ROLE" == "MASTER" ]; then
  pwd
elif [ "$ROLE" == "SLAVE" ]; then
  if ! getent hosts $DSCV; then
    echo "=== Cannot resolve the DNS entry for $DSCV. Has the service been created yet, and is SkyDNS functional?"
    echo "=== See http://kubernetes.io/v1.1/docs/admin/dns.html for more details on DNS integration."
    echo "=== Sleeping 10s before pod exit."
    sleep 10
    exit 0
  fi
  MASTER=$(getent hosts $DSCV | awk -F ' ' '{print $1}')
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO]: $MASTER"
  [[ -z "$REDIS_PORT" ]] && REDIS_PORT=6379
  sed -i "s/# slaveof <masterip> <masterport>/slaveof $MASTER_IP $REDIS_PORT/g" ${REDIS_CONF}
else
  echo "=== No such role as $ROLE."
  echo "=== Sleeping 10s before pod exit."
  sleep 10
  exit 0
fi
redis-server ${REDIS_CONF} --protected-mode no
