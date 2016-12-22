source ./func.sh

docker network inspect cluster
if [ $? != 0 ]
then
docker network create cluster --subnet 172.18.0.0/16
fi

docker run -d --name metadata --network cluster --ip 172.18.1.10 -p 9611:9611 qingcloud/metad --listen_manage :9611

sleep 1

curl http://localhost:9611/v1/data -d '{"cl-elasticsearch":{"cluster":{"app_id":"app-es-docker","cluster_id":"cl-elasticsearch","vxnet":"vxnet-es"},"cmd":{"i-node1":{"cmd":"/opt/elasticsearch/bin/start-server.sh","id":"szB4prTgXZs2DF4FKWpiWobT3FxhSsegnx8c","timeout":"600"},"i-node2":{"cmd":"/opt/elasticsearch/bin/start-server.sh","id":"UA5Kf6fjVIrNTcwcpd3QHa5aO9HEOXlYdtrU","timeout":"600"},"i-node3":{"cmd":"/opt/elasticsearch/bin/start-server.sh","id":"9phyzuX8O418tCPNyipLnNjgObPcMvEZpptk","timeout":"600"}},"hosts":{"i-node1":{"ip":"172.18.1.11","sid":"1"},"i-node2":{"ip":"172.18.1.12","sid":"2"},"i-node3":{"ip":"172.18.1.13","sid":"3"}}}}'
curl http://localhost:9611/v1/mapping -d '{"172.18.1.11":{"adding-hosts":"/cl-elasticsearch/adding-hosts","cluster":"/cl-elasticsearch/cluster","cmd":"/cl-elasticsearch/cmd/i-node1","deleting-hosts":"/cl-elasticsearch/deleting-hosts","host":"/cl-elasticsearch/hosts/i-node1","hosts":"/cl-elasticsearch/hosts"},"172.18.1.12":{"adding-hosts":"/cl-elasticsearch/adding-hosts","cluster":"/cl-elasticsearch/cluster","cmd":"/cl-elasticsearch/cmd/i-node2","deleting-hosts":"/cl-elasticsearch/deleting-hosts","host":"/cl-elasticsearch/hosts/i-node2","hosts":"/cl-elasticsearch/hosts"},"172.18.1.13":{"adding-hosts":"/cl-elasticsearch/adding-hosts","cluster":"/cl-elasticsearch/cluster","cmd":"/cl-elasticsearch/cmd/i-node3","deleting-hosts":"/cl-elasticsearch/deleting-hosts","host":"/cl-elasticsearch/hosts/i-node3","hosts":"/cl-elasticsearch/hosts"}}'

docker run -d -m 512m --name elasticsearch1 --network cluster --ip 172.18.1.11  dockerhub.qingcloud.com/qingcloud/elasticsearch
docker run -d -m 512m --name elasticsearch2 --network cluster --ip 172.18.1.12  dockerhub.qingcloud.com/qingcloud/elasticsearch
docker run -d -m 512m --name elasticsearch3 --network cluster --ip 172.18.1.13  dockerhub.qingcloud.com/qingcloud/elasticsearch

sleep 10

docker run --rm --network cluster jolestar/dockerbox curl "http://172.18.1.13:9200/_cluster/health?pretty"

for i in `seq 1 3`;
do
	echo "cat elasticsearch$i config"
	docker exec elasticsearch$i cat /opt/elasticsearch/config/elasticsearch.yml
done
