FROM dockerhub.qingcloud.com/qingcloud/jdk
MAINTAINER jolestar <jolestar@gmail.com>

ARG VERSION=2.4.1
ARG URL=https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$VERSION/elasticsearch-$VERSION.tar.gz

LABEL name="elasticsearch" version=$VERSION

RUN mkdir /opt \
    && curl -L -s $URL | tar -xzf - -C /opt 
RUN ls /opt &&  mv /opt/elasticsearch-$VERSION /opt/elasticsearch

EXPOSE 9200 9300

WORKDIR /opt/elasticsearch

COPY conf.d/* /etc/confd/conf.d/
COPY templates/*  /etc/confd/templates/
COPY bin/* /opt/elasticsearch/bin/
