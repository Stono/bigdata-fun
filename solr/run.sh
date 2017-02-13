#!/bin/bash
set -e
echo Starting Solr...
chown -R solr:solr /data
cd /opt/solr

if [ ! -f "/data/solr.xml" ]; then
  echo "Using default config..."
  cp /opt/solr/server/solr/solr.xml /data/
  cp -R /opt/solr/server/solr/configsets /data/
fi

echo Checking solr zookeeper node exists on $HBASE_CONF_QUORUM...
set +e
su -c "./bin/solr zk ls /solr -z $HBASE_CONF_QUORUM:2181 &>/dev/null" &>/dev/null solr
EXIT_CODE=$?
set -e

if [ ! "$EXIT_CODE" = "0" ]; then
  echo Creating solr zookeeper node...
  su -c "./bin/solr zk mkroot /solr -z $HBASE_CONF_QUORUM:2181"
fi
su -c "./bin/solr -s /data -p 8983 -f -c -z $HBASE_CONF_QUORUM:2181/solr" solr
