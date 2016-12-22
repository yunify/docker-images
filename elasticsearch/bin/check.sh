#!/bin/bash

. /opt/elasticsearch/bin/env.sh
curl -XGET -s "http://localhost:$DEFAULT_ES_PORT/_cluster/health?pretty=true"|grep status
result=$?
echo $result
exit $result
