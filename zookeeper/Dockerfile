FROM dockerhub.qingcloud.com/qingcloud/jdk8
MAINTAINER Jolestar <jolestar@gmail.com>

ARG MIRROR=http://mirror.bit.edu.cn/apache
ARG VERSION=3.4.9

LABEL name="zookeeper" version=$VERSION

RUN mkdir -p /opt \
    && curl -L -s $MIRROR/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

COPY conf.d/* /etc/confd/conf.d/
COPY templates/*  /etc/confd/templates/
COPY bin/* /opt/zookeeper/bin/
