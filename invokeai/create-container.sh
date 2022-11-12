#!/bin/bash

progname=$(basename $0)

usage="
Usage: ${progname} [-h] [-c <configsdir> -l <logsdir> -m <modelsdir>
       -o <outputsdir> -t <trainingdir> | -b <basedir>] [-n <name>]

  -b  Base directory that contains directories \"configs/\", \"logs\",
      \"models/ldm/stable-diffusion-v1/\", \"outputs/\", and \"training-data/\".
  -c  Local directory to mount to \"configs\".
  -h  Show this usage statement.
  -l  Local directory to mount to \"logs\".
  -m  Local directory to mount to \"models\".
  -n  Name for the container.  [Default:\"invokeai\"]
  -o  Local directory to mount to \"outputs\".
  -t  Local directory to mount to \"training\".

  Volumes used by container:
    - configs:/InvokeAI/configs/
    - logs:/InvokeAI/logs/
    - models:/InvokeAI/models/ldm/stable-diffusion-v1/
    - outputs:/InvokeAI/outputs/
    - training:/InvokeAI/training-data/
"

optBase=""
optConfigs=""
optLogs=""
optModels=""
optName="invokeai"
optOutputs=""
optTraining=""

usage() { echo "$usage" 1>&2; exit 1; }

while getopts ":b:c:hl:m:n:o:t:" options; do
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
    l)
      optLogs=${OPTARG}
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
  "$optLogs" = "" || \
  "$optModels" = "" || \
  "$optOutputs" = "" || \
  "$optTraining" = "" )
  ) || \
  ( "$optBase" != "" && ( \
  "$optConfigs" != "" || \
  "$optLogs" != "" || \
  "$optModels" != "" || \
  "$optOutputs" != "" || \
  "$optTraining" != "" ) \
  ) ]]; then
  usage
fi

if [ "$optBase" != "" ]; then
  optConfigs="${optBase}/configs/"
  optLogs="${optBase}/logs/"
  optModels="${optBase}/models/ldm/stable-diffusion-v1/"
  optOutputs="${optBase}/outputs/"
  optTraining="${optBase}/training-data/"
fi

docker run \
  --gpus all \
  --name $optName \
  -d \
  -v ${optConfigs}:/InvokeAI/configs/ \
  -v ${optLogs}:/InvokeAI/logs/ \
  -v ${optModels}:/InvokeAI/models/ldm/stable-diffusion-v1/ \
  -v ${optOutputs}:/InvokeAI/outputs/ \
  -v ${optTraining}:/InvokeAI/training-data/ \
  -p 9090:9090 \
  wpafbo79/invokeai
