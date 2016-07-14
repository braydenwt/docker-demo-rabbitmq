#! /usr/bin/env bash
set -e

# check arguments
[ $# -gt 0 ] || { echo "Usage: $0 folder" ; exit 1; }

# validate folder
srcDir="./src/$1"
[ -d $srcDir ] || { echo "Src folder \"$srcDir\" not found"; exit 1; }

# check if javac avaiable
[ $(which javac) ] || { echo "javac not installed"; exit 1; }

# check javac version (1.7.*)
javac -version 2>&1 | grep "1.7.[0-9]" 1>/dev/null || { echo "javac 1.7.* is required"; exit 1; }

# ceate the output folder if not exists
outputDir="./output/$1"
[ -d $outputDir ] || mkdir -p $outputDir

# cleanup
rm $outputDir/*

# compile
javac -classpath "./src/libs/rabbitmq-client.jar" $srcDir/*.java -d $outputDir

# copy the dependencies
cp ./src/libs/*.jar $outputDir
cp ./src/$1/*.sh $outputDir

[ -f $outputDir/entry.sh ] && chmod +x $outputDir/entry.sh

# build docker image
# docker build -t ubuntu-jdk7 .
