#! /usr/bin/env bash

ports_expose="-p 4369:4369 -p 5671:5671 -p 5672:5672 -p 15671:15671 -p 15672:15672 -p 25672:25672"
# ports_expose="--publish-all"

docker run -d --hostname rabbitmq-dev1 --name rabbitmq-server $ports_expose rabbitmq:3-management

docker run -d --name rabbitmq-publisher --link rabbitmq-server --volume $(pwd)/output:/var/workspace ubuntu-jdk7 ./entry.sh Send 2>&1

docker run -d --name rabbitmq-subscriber --link rabbitmq-server --volume $(pwd)/output:/var/workspace ubuntu-jdk7 ./entry.sh Recv 2>&1