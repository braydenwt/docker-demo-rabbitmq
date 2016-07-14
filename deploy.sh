#! /usr/bin/env bash
set -e

# check arguments
[ $# -gt 0 ] || { echo "Usage: $0 folder" ; exit 1; }

# validate folder
outputDir="./output/$1"
[ -d $outputDir ] || { echo "output folder \"$outputDir\" not found" ; exit 1; }

. $outputDir/deploy.sh