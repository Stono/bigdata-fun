#!/bin/bash
set -e

sed -i -e "s,solr: \"/.*/\",solr: \"$SOLR_HOST:$SOLR_PORT/$SOLR_DOMAIN\",g" /opt/banana/src/config.js
sed -i -e "s,\"server\": \"/.*/\",\"server\": \"$SOLR_HOST:$SOLR_PORT/$SOLR_DOMAIN\",g" /opt/banana/src/app/dashboards/default.json

cd /opt/banana
./node_modules/http-server/bin/http-server -a 0.0.0.0 -p 8000
