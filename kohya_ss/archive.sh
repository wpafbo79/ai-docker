#!/bin/bash

set -e
set -u
set -o pipefail

source config.sh

mkdir -p ${ARCHIVE_DIR}

for opt in ${!VOLUMES[@]}; do
  dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)

  basedir=$(dirname ${dir})
  leaf=$(basename ${dir} /)

  mkdir -p ${dir}
  cp -rl ${dir} ${ARCHIVE_DIR}
done
