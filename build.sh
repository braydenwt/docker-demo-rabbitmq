#! /usr/bin/env bash

# check if javac avaiable
[ $(which javac) ] || { echo "javac not installed"; exit 1; }

# ceate the output folder if not exists
[ -d ./output ] || mkdir ./output

# TODO: check javac version (1.7+) 

# compile
javac -classpath "./src/libs/rabbitmq-client.jar" ./src/*.java -d ./output

# copy the dependencies
cp ./src/libs/*.jar ./output/

cp ./src/entry.sh ./output/

[ -f ./output/entry.sh ] && chmod +x ./output/entry.sh

