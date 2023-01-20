#!/bin/bash

set -e
set -u
set -o pipefail

source config.sh

# Copy data from directories covered by volumes to populate volumes.
for vol in ${!VOLUMES[@]}; do
  dir=$(echo ${VOLUMES[${vol}]} | cut -d ":" -f 2)
  leaf=$(basename ${dir} /)

  echo rsync -HaAxX --progress --ignore-existing ${ARCHIVE_DIR}/${leaf}/ ${dir}/
  rsync -v -HaAxX --progress --ignore-existing ${ARCHIVE_DIR}/${leaf}/ ${dir}/
done
