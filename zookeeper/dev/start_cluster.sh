source ./func.sh

docker network rm cluster
docker network create cluster --subnet 172.18.0.0/16

docker stop metadata
docker rm metadata

docker run -d --name metadata --network cluster --ip 172.18.1.10 -p 9611:9611 qingcloud/metad --listen_manage :9611

sleep 1

curl http://localhost:9611/v1/data -d '{"cl-zookeeper":{"cluster":{"app_id":"app-zk-docker","cluster_id":"cl-zookeeper","vxnet":"vxnet-zk"},"cmd":{"i-node1":{"cmd":"/opt/zookeeper/bin/zkServer.sh start","id":"szB4prTgXZs2DF4FKWpiWobT3FxhSsegnx8c","timeout":"600"},"i-node2":{"cmd":"/opt/zookeeper/bin/zkServer.sh start","id":"UA5Kf6fjVIrNTcwcpd3QHa5aO9HEOXlYdtrU","timeout":"600"},"i-node3":{"cmd":"/opt/zookeeper/bin/zkServer.sh start","id":"9phyzuX8O418tCPNyipLnNjgObPcMvEZpptk","timeout":"600"}},"hosts":{"i-node1":{"ip":"172.18.1.11","sid":"1"},"i-node2":{"ip":"172.18.1.12","sid":"2"},"i-node3":{"ip":"172.18.1.13","sid":"3"}}}}'
curl http://localhost:9611/v1/mapping -d '{"172.18.1.11":{"adding-hosts":"/cl-zookeeper/adding-hosts","cluster":"/cl-zookeeper/cluster","cmd":"/cl-zookeeper/cmd/i-node1","deleting-hosts":"/cl-zookeeper/deleting-hosts","host":"/cl-zookeeper/hosts/i-node1","hosts":"/cl-zookeeper/hosts"},"172.18.1.12":{"adding-hosts":"/cl-zookeeper/adding-hosts","cluster":"/cl-zookeeper/cluster","cmd":"/cl-zookeeper/cmd/i-node2","deleting-hosts":"/cl-zookeeper/deleting-hosts","host":"/cl-zookeeper/hosts/i-node2","hosts":"/cl-zookeeper/hosts"},"172.18.1.13":{"adding-hosts":"/cl-zookeeper/adding-hosts","cluster":"/cl-zookeeper/cluster","cmd":"/cl-zookeeper/cmd/i-node3","deleting-hosts":"/cl-zookeeper/deleting-hosts","host":"/cl-zookeeper/hosts/i-node3","hosts":"/cl-zookeeper/hosts"}}'

docker stop zookeeper1
docker stop zookeeper2
docker stop zookeeper3

docker rm zookeeper1
docker rm zookeeper2
docker rm zookeeper3

docker run -d --name zookeeper1 --network cluster --ip 172.18.1.11  dockerhub.qingcloud.com/qingcloud/zookeeper
docker run -d --name zookeeper2 --network cluster --ip 172.18.1.12  dockerhub.qingcloud.com/qingcloud/zookeeper
docker run -d --name zookeeper3 --network cluster --ip 172.18.1.13  dockerhub.qingcloud.com/qingcloud/zookeeper

sleep 10

zk_servers="172.18.1.11:2181,172.18.1.12:2181,172.18.1.13:2181"

echo "add nodes"

curl http://localhost:9611/v1/data -XPUT -d '{"cl-zookeeper":{"cmd":{"i-node4":{"cmd":"/opt/zookeeper/bin/zkServer.sh start","id":"szB4prTgXZs2DF4FKWpiWobT3FxhSsegnx8c","timeout":"600"},"i-node5":{"cmd":"/opt/zookeeper/bin/zkServer.sh start","id":"UA5Kf6fjVIrNTcwcpd3QHa5aO9HEOXlYdtrU","timeout":"600"}},"hosts":{"i-node4":{"ip":"172.18.1.14","sid":"4"},"i-node5":{"ip":"172.18.1.15","sid":"5"}}}}'

curl http://localhost:9611/v1/mapping -XPUT -d '{"172.18.1.14":{"adding-hosts":"/cl-zookeeper/adding-hosts","cluster":"/cl-zookeeper/cluster","cmd":"/cl-zookeeper/cmd/i-node4","deleting-hosts":"/cl-zookeeper/deleting-hosts","host":"/cl-zookeeper/hosts/i-node4","hosts":"/cl-zookeeper/hosts"},"172.18.1.15":{"adding-hosts":"/cl-zookeeper/adding-hosts","cluster":"/cl-zookeeper/cluster","cmd":"/cl-zookeeper/cmd/i-node5","deleting-hosts":"/cl-zookeeper/deleting-hosts","host":"/cl-zookeeper/hosts/i-node5","hosts":"/cl-zookeeper/hosts"}}'


docker stop zookeeper4
docker stop zookeeper5
docker rm zookeeper4
docker rm zookeeper5

docker run -d --name zookeeper4 --network cluster --ip 172.18.1.14  dockerhub.qingcloud.com/qingcloud/zookeeper
docker run -d --name zookeeper5 --network cluster --ip 172.18.1.15  dockerhub.qingcloud.com/qingcloud/zookeeper

sleep 10

for i in `seq 1 5`;
do
	echo "cat zookeeper$i config"
	docker exec zookeeper$i cat /opt/zookeeper/conf/zoo.cfg
done

echo "delete nodes"
curl http://localhost:9611/v1/data/cl-zookeeper/cmd/?subs=i-node1,i-node2 -XDELETE
curl http://localhost:9611/v1/data/cl-zookeeper/hosts/?subs=i-node1,i-node2 -XDELETE
curl http://localhost:9611/v1/mapping/cl-zookeeper/cmd/?subs=172.18.1.11,172.18.1.12 -XDELETE

docker stop zookeeper1
docker stop zookeeper2

sleep 10

for i in `seq 3 5`;
do
	echo "cat zookeeper$i config"
	docker exec zookeeper$i cat /opt/zookeeper/conf/zoo.cfg
done




