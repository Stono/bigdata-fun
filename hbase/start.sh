#!/bin/bash
set -e
HOSTNAME=$(hostname)
QUORUM=${QUORUM:-$HOSTNAME}

echo "Configuring hbase-site.xml..."
for varname in ${!HBASE_CONF_*}
do
	KEY=${varname}
	VALUE=${!varname}

	echo "  -> KEY: $KEY"
	echo "  -> VALUE: $VALUE"
	echo ""

	envsubst < /opt/hbase/conf/hbase-site.template > /opt/hbase/conf/hbase-site.xml
done

echo "Configuring host file..."
for varname in ${!HOST_ENTRY_*}
do
	KEY=${varname}
	VALUE=${!varname}
	IP=$(getent hosts $VALUE | cut -d' ' -f1)
	
	echo "  -> $IP $VALUE"

	echo "$IP $VALUE" >> /etc/hosts
done

$* 
