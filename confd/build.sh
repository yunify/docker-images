source ./env.sh
docker build -t confd --build-arg CONFD_VERSION=$CONFD_VERSION .
docker tag confd dockerhub.qingcloud.com/qingcloud/confd
docker tag confd dockerhub.qingcloud.com/qingcloud/confd:$CONFD_VERSION
