#!/bin/bash
cd $INDEXER_HOME

sleep 5
for varname in ${!INDEX_COLLECTION_*}
do
	WITHOUT=${varname/INDEX_COLLECTION_/}

	INDEX=${WITHOUT}_idx
	FILE=/data/indices/${WITHOUT}.xml
	COLLECTION=${!varname}

	echo "  -> Creating $INDEX, from $FILE, populating collection $COLLECTION"
	./bin/hbase-indexer add-indexer -n $INDEX \
		-c $FILE \
		-cp solr.zk=$HBASE_CONF_QUORUM \
		-cp solr.collection=$COLLECTION \
		--zookeeper $HBASE_CONF_QUORUM:2181 
done
