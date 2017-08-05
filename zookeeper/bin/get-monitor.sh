#!/bin/bash

data=`echo srvr | nc 127.0.0.1 2181`
if [ $? -ne 0 ]
then
  exit 1
fi
mode=`echo "$data" | grep Mode | awk -F':' '{print $2}' | awk '{$1=$1};1'`
latency=`echo "$data" | grep Latency | awk -F':' '{print $2}' | awk '{$1=$1};1'`
min=`echo "$latency" | awk -F'/' '{print $1}' | awk '{$1=$1};1'`
avg=`echo "$latency" | awk -F'/' '{print $2}' | awk '{$1=$1};1'`
max=`echo "$latency" | awk -F'/' '{print $3}' | awk '{$1=$1};1'`
received=`echo "$data" | grep Received | awk -F':' '{print $2}' | awk '{$1=$1};1'`
sent=`echo "$data" | grep Sent | awk -F':' '{print $2}' | awk '{$1=$1};1'`
active=`echo "$data" | grep Connections | awk -F':' '{print $2}' | awk '{$1=$1};1'`
outstanding=`echo "$data" | grep Outstanding | awk -F':' '{print $2}' | awk '{$1=$1};1'`
znode=`echo "$data" | grep count | awk -F':' '{print $2}' | awk '{$1=$1};1'`

echo "{\"mode\":\"$mode\",\"min\":$min,\"avg\":$avg,\"max\":$max,\"received\":$received, \"sent\":$sent,\"active\":$active,\"outstanding\":$outstanding,\"znode\":$znode}"
