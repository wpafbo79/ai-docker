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
  echo -e "Most recent local Git commit for Kohya GUI:\n"
  git log --max-count=1

  exit
fi

source /.venv/bin/activate

if [ ${optUpdate} -eq 1 ]; then
  echo "Updating to most recent version of Kohya GUI..."

  # Fix issue with files already existing
  export PIP_EXISTS_ACTION=w

  git fetch origin
  git checkout main
  git pull

  source /.venv/bin/activate
  python3 -m pip install --upgrade pip
  deactivate && source /.venv/bin/activate
fi

# Copy data from directories covered by volumes to populate volumes.
./sync-archive.sh

echo "Running Kohya GUI...  (This can take a minute or two.)"
python3 kohya_gui.py \
  --listen=0.0.0.0 \
  --server_port 7680
