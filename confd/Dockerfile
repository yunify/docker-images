FROM alpine:3.4
MAINTAINER jolestar <jolestar@gmail.com>

RUN apk add --no-cache curl bash

ARG CONFD_VERSION=v0.13.13
RUN mkdir -p /opt/qingcloud/app-agent/bin/ && curl -L -s https://github.com/yunify/confd/releases/download/$CONFD_VERSION/confd-alpine-amd64.tar.gz | tar -xzf - -C /opt/qingcloud/app-agent/bin/

ADD root /
RUN chmod +x /opt/qingcloud/app-agent/bin/*.sh

ENTRYPOINT ["/opt/qingcloud/app-agent/bin/confd"]
