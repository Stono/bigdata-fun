#!/bin/bash

if ! hash jq 2>/dev/null; then
  echo You need JQ installed matey!  Please install it first. 
  echo Once you have done that, run ./demo-init.sh
  exit 1
fi
 
echo Creating Users table in HBase...
docker-compose exec master /bin/sh -c "echo \"create 'Users', { NAME => 'cf', REPLICATION_SCOPE => '1' }\" | hbase shell"

export WEB="http://127.0.0.1:17007/nifi"
export API="http://127.0.0.1:17007/nifi-api"
echo Waiting for NiFi to come up...
until $(curl --output /dev/null --silent --head --fail $WEB); do
  printf '.'
  sleep 2
done

echo Creating Templates in NiFi...
export PROCESS_GROUP=$(curl -s $API/flow/process-groups/root | jq .processGroupFlow.id)
export PROCESS_GROUP=$(echo $PROCESS_GROUP | tr -d '"')
echo Process group: $PROCESS_GROUP

curl -s -iv -F template=@config/nifi/users.xml $API/process-groups/$PROCESS_GROUP/templates/upload &>/dev/null
 
export TEMPLATE_ID=$(curl -s $API/flow/templates | jq .templates | jq '.[]'.id)
export TEMPLATE_ID=$(echo $TEMPLATE_ID | tr -d '"')
echo Template id: $TEMPLATE_ID

export PAYLOAD="{\"templateId\":\"$TEMPLATE_ID\",\"originX\":365,\"originY\":-21}"

curl -s -kH "Content-Type: application/json" -X POST -d $PAYLOAD $API/process-groups/$PROCESS_GROUP/template-instance &>/dev/null

echo Opening NiFi...
echo At this point - you need to enable each of the processors on the left most group
echo and then start the Fetch User Data one.
echo This will import approx 1000 rows every 20 seconds so do not leave it running too long.
echo You can then go and see those rows in HBase.

open $WEB 
