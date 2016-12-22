#!/bin/bash

. /opt/elasticsearch/bin/env.sh
. /lib/lsb/init-functions

PID_FILE=$ES_PID_FILE

log_daemon_msg "Restarting $DESC"

if [ ! -f "$PID_FILE" ]; then
	log_daemon_msg "Elasticsearch server not running."
	exit 1
fi
$ES_BIN_PATH/stop-server.sh
sleep 1
$ES_BIN_PATH/start-server.sh
return=$?

if [ $return -eq 0 ]; then
    i=0
    timeout=$ES_SCRIPT_TIMEOUT
    until { $ES_BIN_PATH/check.sh; } >/dev/null 2>&1
    do
sleep 1
i=$(($i + 1))
if [ $i -gt $timeout ]; then
    log_end_msg 1
    exit 1
fi
    done
fi
exit $return
