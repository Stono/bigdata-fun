#!/bin/bash
set -e

if ! hash jq 2>/dev/null; then
  echo You need JQ installed matey!  Please install it first.
  exit 1
fi
 
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

export WEB="http://127.0.0.1:8082/nifi"
export API="http://127.0.0.1:8082/nifi-api"
echo Waiting for NiFi to come up...
until $(curl --output /dev/null --silent --head --fail $WEB); do
  printf '.'
  sleep 2
done

echo Creating Templates in NiFi...
export PROCESS_GROUP=$(curl --silent $API/flow/process-groups/root | jq .processGroupFlow.id)
export PROCESS_GROUP=$(echo $PROCESS_GROUP | tr -d '"')
echo Process group: $PROCESS_GROUP

curl -iv -F template=@config/nifi/users.xml $API/process-groups/$PROCESS_GROUP/templates/upload > /dev/null
 
export TEMPLATE_ID=$(curl --silent $API/flow/templates | jq .templates | jq '.[]'.id)
export TEMPLATE_ID=$(echo $TEMPLATE_ID | tr -d '"')
echo Template id: $TEMPLATE_ID

export PAYLOAD="{\"templateId\":\"$TEMPLATE_ID\",\"originX\":365,\"originY\":-21}"

curl -kH "Content-Type: application/json" -X POST -d $PAYLOAD $API/process-groups/$PROCESS_GROUP/template-instance > /dev/null

echo Opening NiFi...
open $WEB 
