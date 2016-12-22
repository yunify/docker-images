#!/bin/bash

. /opt/elasticsearch/bin/env.sh
. /lib/lsb/init-functions
DESC="elasticsearch service"
PID_FILE=$ES_PID_FILE
status_of_proc -p $PID_FILE elasticsearch elasticsearch && exit 0 || exit $?
