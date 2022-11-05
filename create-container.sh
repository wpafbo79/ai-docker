#!/bin/bash

progname=$(basename $0)

usage="
Usage: ${progname} [-h] [-c <configsdir> -m <modelsdir> -o <outputsdir>
       -t <trainingdir> | -b <basedir>] [-n <name>]

  -b  Base directory that contains directories \"configs/\",
      \"models/ldm/stable-diffusion-v1/\", \"outputs/\", and \"training-data/\".
  -c  Local directory to mount to \"configs\".
  -h  Show this usage statement.
  -m  Local directory to mount to \"models\".
  -n  Name for the container.  [Defaults:\"invokeai\"]
  -o  Local directory to mount to \"outputs\".
  -t  Local directory to mount to \"training\".

  Volumes used by container:
    - configs:/InvokeAI/configs/
    - models:/InvokeAI/models/ldm/stable-diffusion-v1/
    - outputs:/InvokeAI/outputs/
    - training:/InvokeAI/training-data/
"

optBase=""
optConfigs=""
optModels=""
optName="invokeai"
optOutputs=""
optTraining=""

usage() { echo "$usage" 1>&2; exit 1; }

while getopts ":b:c:hm:n:o:t:" options; do
  case "${options}" in
    b)
      optBase=${OPTARG}
      ;;
    c)
      optConfigs=${OPTARG}
      ;;
    h)
      usage
      ;;
    m)
      optModels=${OPTARG}
      ;;
    n)
      optName=${OPTARG}
      ;;
    o)
      optOutputs=${OPTARG}
      ;;
    t)
      optTraining=${OPTARG}
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
  "$optConfigs" = "" || \
  "$optModels" = "" || \
  "$optOutputs" = "" || \
  "$optTraining" = "" )
  ) || \
  ( "$optBase" != "" && ( \
  "$optConfigs" != "" || \
  "$optModels" != "" || \
  "$optOutputs" != "" || \
  "$optTraining" != "" ) \
  ) ]]; then
  usage
fi

if [ "$optBase" != "" ]; then
  optConfigs="${optBase}/configs/"
  optModels="${optBase}/models/ldm/stable-diffusion-v1/"
  optOutputs="${optBase}/outputs/"
  optTraining="${optBase}/training-data/"
fi

docker run \
  --gpus all \
  --name $optName \
  -d \
  -v ${optConfigs}:/InvokeAI/configs/ \
  -v ${optModels}:/InvokeAI/models/ldm/stable-diffusion-v1/ \
  -v ${optOutputs}:/InvokeAI/outputs/ \
  -v ${optTraining}:/InvokeAI/training-data/ \
  -p 9090:9090 \
  wpafbo79/invokeai
