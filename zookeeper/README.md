# Zookeeper AppCenter Docker镜像示例

## confd 系统文件
1. confd
*  confd.toml
*  conf.d/cmd.info.toml
*  templates/cmd.info.tmpl

## Zookeeper 相关文件
1. conf.d/myid.toml
*  conf.d/zoo.cfg.toml
*  templates/myid.tmpl
*  templates/zoo.cfg.tmpl
*  restart-server.sh

## 本地开发环境模拟
1. 通过Docker创建一个私有网络，并且指定ip段
* 启动metad模拟服务器端的metad
* 通过curl创建metadata，模拟集群
* 通过docker镜像启动服务，触发confd的配置变更以及启动命令
* 通过增删节点模拟集群伸缩

具体参看 [dev/start_cluster.sh](dev/start_cluster.sh)

更多说明参看：
[appcenter/developer-guide](https://docs.qingcloud.com/appcenter/developer-guide)
