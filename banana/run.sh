#!/bin/bash
set -e

# Configure banana
sed -i -e "s,solr: \"/.*/\",solr: \"$SOLR_HOST:$SOLR_PORT/$SOLR_DOMAIN\",g" /opt/banana/src/config.js

# Configure the default dashboard
sed -i -e "s,\"server\": \"/.*/\",\"server\": \"$CLIENT_SOLR_HOST:$CLIENT_SOLR_PORT/$SOLR_DOMAIN\",g" /opt/banana/src/app/dashboards/default.json
sed -i -e "s,collection1,$CLIENT_INITIAL_COLLECTION,g" /opt/banana/src/app/dashboards/default.json

cd /opt/banana
./node_modules/http-server/bin/http-server -a 0.0.0.0 -p 8000
