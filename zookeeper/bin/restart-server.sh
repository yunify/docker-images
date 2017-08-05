#!/bin/bash

/opt/zookeeper/bin/zkServer.sh status
# Restart zk server
if [ $? -eq 0 ]; then
    /opt/zookeeper/bin/zkServer.sh restart
    if [ $? -eq 0 ]; then
        echo "Restart zk server successful"
	    exit 0
	else
	    echo "Failed to restart zk server" 1>&2
	    exit 1
	fi
else
    echo "zk server is not running" 1>&2
		if echo 'ruok' | nc 127.0.0.1 2181; then
			echo "zk server is suspended， try stop and start."
			/opt/zookeeper/bin/zkServer.sh restart
		fi
    exit 0
fi
