#!/bin/bash

progname=$(basename $0)

usage="
Usage: ${progname} [-h] [-i <inputssdir> -m <modelsdir> -r <resultsdir> |
       -b <basedir>] [-n <name>]

  -b  Base directory that contains directories \"inputs/\",
      \"experiments/pretrained_models/\", and \"results/\".
  -h  Show this usage statement.
  -i  Local directory to mount to \"inputs\".
  -m  Local directory to mount to \"experiments/pretrained_models\".
  -n  Name for the container.  [Default:\"gfpgan\"]
  -r  Local directory to mount to \"results\".

  Volumes used by container:
    - inputs:/GFPGAN/inputs/
    - models:/GFPGAN/experiments/pretrained_models/
    - results:/GFPGAN/results/
"

optBase=""
optInputs=""
optModels=""
optName="gfpgan"
optResults=""

usage() { echo "$usage" 1>&2; exit 1; }

while getopts ":b:hi:m:n:r:" options; do
  case "${options}" in
    b)
      optBase=${OPTARG}
      ;;
    h)
      usage
      ;;
    i)
      optInputs=${OPTARG}
      ;;
    m)
      optModels=${OPTARG}
      ;;
    n)
      optName=${OPTARG}
      ;;
    r)
      optResults=${OPTARG}
      ;;
    *)
      usage

      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [[ ( \
  "$optBase" = "" && ( \
  "$optInputs" = "" || \
  "$optModels" = "" || \
  "$optResults" = "" )
  ) || \
  ( "$optBase" != "" && ( \
  "$optInputs" != "" || \
  "$optModels" != "" || \
  "$optResults" != "" ) \
  ) ]]; then
  usage
fi

if [ "$optBase" != "" ]; then
  optInputs="${optBase}/inputs/"
  optModels="${optBase}/experiments/pretrained_models/"
  optResults="${optBase}/results/"
fi

docker run \
  --gpus all \
  --name $optName \
  -d \
  -v ${optInputs}:/GFPGAN/inputs/ \
  -v ${optModels}:/GFPGAN/experiments/pretrained_models/ \
  -v ${optResults}:/GFPGAN/results/ \
  wpafbo79/gfpgan
