FROM      10.128.43.55:5000/ubuntu

MAINTAINER me <me@qp1.org>

RUN apt-get update && apt-get install -y openjdk-7-jre

RUN [ -d /var/workspace ] || mkdir /var/workspace

VOLUME /var/workspace

WORKDIR /var/workspace
