#!/bin/bash

progname=$(basename $0)

usage="
Usage: ${progname} [-h] [-i <inputssdir> -m <modelsdir> -r <resultsdir>
       -w <weightsdir> | -b <basedir>] [-n <name>]

  -b  Base directory that contains directories \"inputs/\",
      \"experiments/pretrained_models/\", and \"results/\".
  -h  Show this usage statement.
  -i  Local directory to mount to \"inputs\".
  -m  Local directory to mount to \"experiments/pretrained_models\".
  -n  Name for the container.  [Default:\"real-esrgan\"]
  -r  Local directory to mount to \"results\".
  -w  Local directory to mount to \"weights\".

  Volumes used by container:
    - inputs:/Real-ESRGAN/inputs/
    - models:/Real-ESRGAN/experiments/pretrained_models/
    - results:/Real-ESRGAN/results/
"

optBase=""
optInputs=""
optModels=""
optName="real-esrgan"
optResults=""
optWeights=""

usage() { echo "$usage" 1>&2; exit 1; }

while getopts ":b:hi:m:n:r:w:" options; do
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
    w)
      optWeights=${OPTARG}
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
  "$optResults" = "" || \
  "$optWeights" = "" )
  ) || \
  ( "$optBase" != "" && ( \
  "$optInputs" != "" || \
  "$optModels" != "" || \
  "$optResults" != ""  || \
  "$optWeights" != "" ) \
  ) ]]; then
  usage
fi

if [ "$optBase" != "" ]; then
  optInputs="${optBase}/inputs/"
  optModels="${optBase}/experiments/pretrained_models/"
  optResults="${optBase}/results/"
  optWeights="${optBase}/weights/"
fi

docker run \
  --gpus all \
  --name $optName \
  -d \
  -v ${optInputs}:/Real-ESRGAN/inputs/ \
  -v ${optModels}:/Real-ESRGAN/experiments/pretrained_models/ \
  -v ${optResults}:/Real-ESRGAN/results/ \
  -v ${optWeights}:/Real-ESRGAN/weights/ \
  wpafbo79/real-esrgan
