#!/bin/bash
set -e

echo Building base images...
docker-compose -f compose.build.yml build

echo Starting HDFS...
docker-compose up -d namenode datanode1 datanode2 

echo Starting HBase...
docker-compose up -d zookeeper master regionserver thrift rest

echo "Starting Lilly, Solr and Banana (ELK, lol)..."
docker-compose up -d lily solr banana

echo Starting NIFI...
docker-compose up -d nifi

echo Starting Hue...
docker-compose up -d hue

./demo-init.sh
