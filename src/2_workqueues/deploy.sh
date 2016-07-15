#! /usr/bin/env bash

# check arguments
[ $# -gt 0 ] || { echo "Usage: $0 folder" ; exit 1; }

# validate folder
outputDir="./output/$1"
[ -d $outputDir ] || { echo "output folder \"$outputDir\" not found" ; exit 1; }

ports_expose="-p 4369:4369 -p 5671:5671 -p 5672:5672 -p 15671:15671 -p 15672:15672 -p 25672:25672"
docker run -d --hostname rabbitmq-dev1 --name rabbitmq-server $ports_expose rabbitmq:3-management

# local
# ( cd $outputDir && ./entry.sh NewTask & )
# dockerized
docker run -d --name rabbitmq-taskmgr --link rabbitmq-server --volume $(pwd)/output/$1:/var/workspace ubuntu-jdk7 ./entry.sh NewTask 2>&1

for (( i = 1; i <= 2; i++ )); do
  echo "creating instance: No.$i"
# local
# ( cd $outputDir && ./entry.sh Worker & )
# dockerized
  docker run -d --name rabbitmq-worker$i --link rabbitmq-server --link rabbitmq-taskmgr --volume $(pwd)/output/$1:/var/workspace ubuntu-jdk7 ./entry.sh Worker 2>&1
done

# make sure the "nc" non-zero exit code won't terminate the script.
set +e
nc -z -w 1 $(docker-machine ip) 15672
while [ $? -ne 0 ]; do
  echo "remote port is not ready. retry in one second .." 
  sleep 1;
  nc -z -w 1 $(docker-machine ip) 15672
done
open http://$(docker-machine ip):15672

# tshark -i vboxnet0 -f "dst port 5672"