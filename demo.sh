#!/bin/bash
set -e 
echo Starting HDFS...
docker-compose up -d namenode datanode1 datanode2 

echo Starting HBase...
docker-compose up -d hbase_zookeeper hbase_master hbase_regionserver hbase_thrift hbase_rest

echo "Starting Lilly, Solr and Banana (ELK, lol)..."
docker-compose up -d lily solr banana

echo Starting NIFI...
docker-compose up -d nifi

echo Starting Hue...
docker-compose up -d hue

echo Creating Users table in HBase...
docker-compose exec hbase_master /bin/sh -c "echo \"create 'User', { NAME => 'cf', REPLICATION_SCOPE => '1' }\" | hbase shell"

echo Creating Templates in Hue...
API="http://127.0.0.1:8082/nifi-api"
PROCESS_GROUP=$(curl --silent $API/flow/process-groups/root | jq .processGroupFlow.id)
PROCESS_GROUP=$(echo $PROCESS_GROUP | tr -d '"')

curl -iv -F template=@config/hue/users.xml $API/process-groups/$PROCESS_GROUP/templates/upload  

TEMPLATE_ID=$(curl --silent $API/flow/templates | jq .templates | jq '.[]'.id)
TEMPLATE_ID=$(echo $TEMPLATE_ID | tr -d '"')

PAYLOAD="{\"templateId\":\"$TEMPLATE_ID\",\"originX\":365,\"originY\":-21}"

curl -kH "Content-Type: application/json" -X POST -d $PAYLOAD $API/process-groups/$PROCESS_GROUP/template-instance

open "http://127.0.0.1:8082/nifi"
