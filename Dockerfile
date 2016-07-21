FROM      10.128.43.55:5000/ubuntu

MAINTAINER me <me@qp1.org>

# use china mirror
RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y openjdk-7-jdk

RUN [ -d /var/workspace ] || mkdir /var/workspace

VOLUME /var/workspace

WORKDIR /var/workspace
