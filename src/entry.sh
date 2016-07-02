#! /usr/bin/env bash
[ $# -ne 1 ] && { echo "one argument required: Send or Recv"; exit 1; }
java -cp .:commons-io-1.2.jar:commons-cli-1.1.jar:rabbitmq-client.jar $1 
