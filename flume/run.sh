#!/bin/bash
set -e

FLUME_CONF_DIR=${FLUME_CONF_DIR:-"/opt/flume/conf"}
FLUME_CONF_FILE=${FLUME_CONF_FILE:-"/opt/flume/conf/flume-conf.properties"}
FLUME_AGENT_NAME=${FLUME_AGENT_NAME:-$HOSTNAME}

echo "Starting flume agent: ${FLUME_AGENT_NAME}"

if [ ! -f "$FLUME_HOME/conf/flume-conf.properties" ]; then
  echo "No configuration file found, using template..."
  mv $FLUME_HOME/flume-conf.properties.template $FLUME_HOME/conf/flume-conf.properties
fi

if [ ! -f "$FLUME_HOME/conf/log4j.properties" ]; then
  echo "No log4j configuration file found, using template..."
  mv $FLUME_HOME/log4j.properties $FLUME_HOME/conf/
fi

$FLUME_HOME/bin/flume-ng agent -c ${FLUME_CONF_DIR} -f ${FLUME_CONF_FILE} -n ${FLUME_AGENT_NAME} 
