#! /usr/bin/env bash

# ceate the output folder if not exists
[ -d ./output ] || mkdir ./output

# compile
javac -classpath "./src/libs/rabbitmq-client.jar" ./src/*.java -d ./output

# copy the dependencies
cp ./src/libs/*.jar ./output/
