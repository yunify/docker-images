source ./env.sh
docker push dockerhub.qingcloud.com/qingcloud/confd
docker push dockerhub.qingcloud.com/qingcloud/confd:$CONFD_VERSION
