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
  -n  Name for the container.  [Default:\"basujindal-stable-diffusion\"]
  -o  Local directory to mount to \"outputs\".
  -t  Local directory to mount to \"training\".

  Volumes used by container:
    - configs:/stable-diffusion/configs/
    - logs:/stable-diffusion/logs/
    - models:/stable-diffusion/models/ldm/stable-diffusion-v1/
    - outputs:/stable-diffusion/outputs/
    - training:/stable-diffusion/training-data/
"

optBase=""
optConfigs=""
optLogs=""
optModels=""
optName="basujindal-stable-diffusion"
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
  -v ${optConfigs}:/stable-diffusion/configs/ \
  -v ${optLogs}:/stable-diffusion/logs/ \
  -v ${optModels}:/stable-diffusion/models/ldm/stable-diffusion-v1/ \
  -v ${optOutputs}:/stable-diffusion/outputs/ \
  -v ${optTraining}:/stable-diffusion/training-data/ \
  wpafbo79/basujindal-stable-diffusion
