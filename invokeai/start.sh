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
  -p  Preload modules.
  -u  Update to most recent repository commit.
"

optGitLog=0
optPreload=0
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
    p)
      optPreload=1
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
  echo -e "Most recent local Git commit for InvokeAI:\n"
  git log --max-count=1

  exit
fi

source .venv/bin/activate

if [ ${optUpdate} -eq 1 ]; then
  echo "Updating to most recent version of InvokeAI..."

  # Fix issue with files already existing
  export PIP_EXISTS_ACTION=w

  git fetch origin
  git checkout main
  git pull

  source .venv/bin/activate
  python3 -m pip install --upgrade pip
  pip install --use-pep517 .
  deactivate && source .venv/bin/activate
fi

if [ ${optPreload} -eq 1 ]; then
  echo "Preloading models..."
  invokeai-configure --root=$(pwd)
  
  exit
fi

# Copy data from directories covered by volumes to populate volumes.
./sync-archive.sh

if [[ $(ls models/diffusers/models--* | wc -l) -eq 0 &&
      $(ls models/ldm/stable-diffusion-v1/*.ckpt | wc -l) -eq 0 ]] ||
  [[ $(ls configs/models.yaml | wc -l) -eq 0 ]]; then
  cat <<EOF
No model found!
Please run an interactive command to download models.

  $ docker exec -it <container> /bin/bash
  (base) root:/InvokeAI# ./${progname} -p

Follow the instructions to download the models.

Sleeping for 24 hours to allow time for the models to download.
Restart container when the models are done downloading.
EOF

  sleep 24h

  exit
fi

echo "Running InvokeAI...  (This can take a few minutes.)"
invokeai \
  --web --host=0.0.0.0 \
  --no-nsfw_checker \
  --root_dir="$(pwd)"
