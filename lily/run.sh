#!/bin/bash
set -e
cd $INDEXER_HOME

/usr/local/bin/add_indices.sh &
PID=$!

function finish {
  kill -s 0 $PID >/dev/null 2>&1
}
trap finish TERM INT

./bin/hbase-indexer server
