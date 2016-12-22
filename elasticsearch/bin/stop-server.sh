#!/bin/bash

. /opt/elasticsearch/bin/env.sh
. /lib/lsb/init-functions
DESC="elasticsearch service"
PID_FILE=$ES_PID_FILE

log_daemon_msg "Stopping $DESC"
if [ -f "$PID_FILE" ]; then
    start-stop-daemon --stop --pidfile "$PID_FILE" \
--user "$ES_USER" \
--quiet \
--retry TERM/30/KILL/10/KILL/10 > /var/log/elasticsearch_stop.log
    if [ $? -eq 1 ]; then
log_progress_msg "$DESC is not running but pid file exists, cleaning up"
    elif [ $? -eq 3 ]; then
PID="`cat $PID_FILE`"
log_failure_msg "Failed to stop $DESC (pid $PID)"
exit 1
    fi
    rm -f "$PID_FILE"
else
    log_progress_msg "(not running)"
fi
log_end_msg 0
