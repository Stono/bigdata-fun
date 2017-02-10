#!/bin/bash
set -e
HOSTNAME=$(hostname)
QUORUM=${QUORUM:-$HOSTNAME}

sed -i "s/HOSTNAME/$HOSTNAME/g" /opt/hbase/conf/hbase-site.xml
sed -i "s/QUORUM/$QUORUM/g" /opt/hbase/conf/hbase-site.xml

$* 
