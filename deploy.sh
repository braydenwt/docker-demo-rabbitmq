#! /usr/bin/env bash

ports_expose="-p 4369:4369 -p 5671:5671 -p 5672:5672 -p 15671:15671 -p 15672:15672 -p 25672:25672"
# ports_expose="--publish-all"

docker run -d --hostname rabbitmq-dev1 --name rabbitmq-server $ports_expose rabbitmq:3-management

# build image
docker build -t ubuntu-jdk7 .

# seems we need to wait until the rabbitmq-server is fully started.
docker run -d --name rabbitmq-publisher --link rabbitmq-server --volume $(pwd)/output:/var/workspace ubuntu-jdk7 ./entry.sh Send

docker run -d --name rabbitmq-subscriber1 --link rabbitmq-server --volume $(pwd)/output:/var/workspace ubuntu-jdk7 ./entry.sh Recv

docker run -d --name rabbitmq-subscriber2 --link rabbitmq-server --volume $(pwd)/output:/var/workspace ubuntu-jdk7 ./entry.sh Recv