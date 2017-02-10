#!/bin/bash
set -e
HOSTNAME=$(hostname)
QUORUM=${QUORUM:-$HOSTNAME}

if [ "$USE_HDFS" = "true" ]; then
  cp /opt/hbase/conf/hbase-site.hdfs.xml /opt/hbase/conf/hbase-site.xml
else
  rm /etc/supervisord.d/zookeeper.service.conf
  rm /etc/supervisord.d/regionserver.service.conf
  cp /opt/hbase/conf/hbase-site.local.xml /opt/hbase/conf/hbase-site.xml
fi

rm /opt/hbase/conf/hbase-site.local.xml
rm /opt/hbase/conf/hbase-site.hdfs.xml

sed -i "s/HOSTNAME/$HOSTNAME/g" /opt/hbase/conf/hbase-site.xml
sed -i "s/QUORUM/$QUORUM/g" /opt/hbase/conf/hbase-site.xml

$* 
