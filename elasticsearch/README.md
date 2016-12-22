# Elasticsearch Docker镜像

## 本地开发环境模拟
1. 通过Docker创建一个私有网络，并且指定ip段
* 启动metad模拟服务器端的metad
* 通过curl创建metadata，模拟集群
* 通过docker镜像启动服务，触发confd的配置变更以及启动命令
* 通过增删节点模拟集群伸缩

具体参看 [dev/start_cluster.sh](dev/start_cluster.sh)

