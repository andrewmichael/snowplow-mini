#!/bin/sh

/etc/init.d/postgresql start && \
/etc/init.d/elasticsearch start && \
/etc/init.d/kibana4_init start && \
/etc/init.d/snowplow_stream_collector_0.6.0 start && \
/etc/init.d/snowplow_stream_enrich_0.7.0 start && \
/etc/init.d/snowplow_elasticsearch_sink_good_0.5.0 start && \
/etc/init.d/snowplow_elasticsearch_sink_bad_0.5.0 start && \
/etc/init.d/iglu_server_0.2.0 start && \
/etc/init.d/nginx start

PGPASSWORD=snowplow  psql -v ON_ERROR_STOP=1 --username snowplow --dbname iglu --host localhost --port 5432 <<-EOSQL
INSERT INTO apikeys (uid, vendor_prefix, permission, createdat) VALUES ('980ae3ab-3aba-4ffe-a3c2-3b2e24e2ffce','*','super',current_timestamp);
EOSQL

curl -f http://localhost:8082

tail -f /dev/null