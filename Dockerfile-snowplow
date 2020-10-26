FROM mrosack/snowplow-mini

COPY resources/configs/snowplow-mini.conf /etc/nginx/conf.d/snowplow-mini.conf
COPY ui /home/ubuntu/snowplow/ui
COPY resources/docker/entrypoint.sh /home/ubuntu/snowplow/docker/entrypoint.sh

ENTRYPOINT /home/ubuntu/snowplow/docker/entrypoint.sh