#!/bin/bash --login

set -e
set -u
set -o pipefail

source config.sh

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
  echo -e "Most recent local Git commit for Stable Diffusion:\n"
  git log --max-count=1

  exit
fi

if [ ${optUpdate} -eq 1 ]; then
  echo "Updating to most recent version of Stable Diffusion..."

  # Fix issue with files already existing
  export PIP_EXISTS_ACTION=w

  git fetch origin
  git checkout main
  git pull

  conda env update --prune
  conda clean --all --yes
fi

conda init bash
conda activate ldm

# Copy data from directories covered by volumes to populate volumes.
./sync-archive.sh

if [ $(ls models/ldm/stable-diffusion-v1/*.ckpt | wc -l) -eq 0 -o \
  $(ls configs/models.yaml | wc -l) -eq 0 ]; then
  cat <<EOF
No model found!
Please download models as described on the project page.
  https://github.com/basujindal/stable-diffusion

Sleeping for 24 hours to allow time for the models to download.
Restart container when the models are done downloading.
EOF

  sleep 24h

  exit
fi

sleep 24h
#echo "Running Stable Diffusion...  (This can take a few minutes.)"
#python3 scripts/txt2img.py ${@}
