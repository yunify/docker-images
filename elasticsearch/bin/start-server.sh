#!/bin/bash

. /opt/elasticsearch/bin/env.sh
. /lib/lsb/init-functions
DESC="elasticsearch service"
PID_FILE=$ES_PID_FILE
DAEMON=$ES_BIN_FILE
DAEMON_OPTS="-d -p $PID_FILE -Des.max-open-files=true"

mem=`cat /proc/meminfo |grep MemTotal|awk '{print $2}'`
heap=$((mem/1024/2))
export ES_HEAP_SIZE=$heap"M"

log_daemon_msg "Starting $DESC"

ulimit -n 131070
ulimit -l unlimited
sysctl -q -w vm.max_map_count=262144
pid=`pidofproc -p $PID_FILE elasticsearch`
if [ -n "$pid" ];then
    log_begin_msg "Already running."
    log_end_msg 0
    exit 0
fi
mkdir -p "$ES_DATA_PATH/data" 
mkdir -p "$ES_DATA_PATH/logs"
chown -R $ES_USER:$ES_GROUP $ES_DATA_PATH
if [ -n "$PID_FILE" ] && [ ! -e "$PID_FILE" ]; then
    touch "$PID_FILE" && chown "$ES_USER":"$ES_GROUP" "$PID_FILE"
fi

start-stop-daemon -d $ES_HOME --start -b --user "$ES_USER" -c "$ES_USER" --pidfile "$PID_FILE" --exec $DAEMON -- $DAEMON_OPTS
return=$?
if [ $return -eq 0 ]; then
i=0
timeout=$((ES_SCRIPT_TIMEOUT-5))
until { kill -0 `cat $PID_FILE`; } >/dev/null 2>&1
do
    sleep 1
    i=$(($i + 1))
    if [ $i -gt $timeout ]; then
log_end_msg 1
exit 1
    fi
done
fi

log_end_msg $return
exit $return
