FROM redis:3.2
RUN mkdir -p /workspace
RUN mkdir -p /usr/local/etc/redis
ADD ./scripts/entrypoint.active-backup.sh /workspace/
ADD ./manifest/redis.conf /usr/local/etc/redis/
