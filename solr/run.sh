#!/bin/bash
set -e
echo Starting Solr in SolrCloud mode...
chown -R solr:solr /data
cd /opt/solr

if [ ! -f "/data/solr.xml" ]; then
  echo "Using default config..."
  cp /opt/solr/server/solr/solr.xml /data/
  cp -R /opt/solr/server/solr/configsets /data/
fi

su -c './bin/solr -s /data -p 8983 -f -c -z hbase-zookeeper:2181' solr
