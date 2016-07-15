#! /usr/bin/env bash

nc -z -w 1 rabbitmq-server 5672
while [ $? -ne 0 ]; do
  echo "remote port is not ready. retry in one second .." 
  sleep 1;
  nc -z -w 1 rabbitmq-server 5672
done

[ $# -ne 1 ] && { echo "one argument required: NewTask or Worker"; exit 1; }
java -cp .:commons-io-1.2.jar:commons-cli-1.1.jar:rabbitmq-client.jar $1 
