#!/bin/bash --login

set -e
set -u
set -o pipefail

progname=$(basename ${0})

usage="
Usage: ${progname} [-g|-h|-p|-u]
  -g  Git log for most recent local commit.
  -h  Show this usage statement.
  -u  Update to most recent repository commit.
"

optGitLog=0
optUpdate=0

usage() { echo "${usage}" 1>&2; exit 1; }

while getopts ":ghpu" options; do
  case "${options}" in
    g)
      optGitLog=1
      ;;
    h)
      usage
      ;;
    u)
      optUpdate=1
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ ${optGitLog} -eq 1 ]; then
  echo -e "Most recent local Git commit for Real-ESRGAN:\n"
  git log --max-count=1

  exit
fi

if [ ${optUpdate} -eq 1 ]; then
  echo "Updating to most recent version of Real-ESRGAN..."

  # Fix issue with files already existing
  export PIP_EXISTS_ACTION=w

  git fetch origin
  git checkout master
  git pull
fi

# Copy data from directories covered by volumes to populate volumes.
./sync-archive.sh

if [ $(ls experiments/pretrained_models/*.pth | wc -l) -eq 0 ]; then
  cat <<EOF
No model found!
Please download models as described on the project page.
  https://github.com/xinntao/Real-ESRGAN

Sleeping for 24 hours to allow time for the models to download.
Restart container when the models are done downloading.
EOF

  sleep 24h

  exit
fi

sleep 24h
#echo "Running Real-ESRGAN...  (This can take a few minutes.)"
