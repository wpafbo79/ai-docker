#!/bin/bash

source config.sh

archive_dir="${INSTALL_DIR}archive/"

mkdir -p ${archive_dir}

for opt in ${!VOLUMES[@]}; do
  dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)

  mkdir -p ${dir}
  mv ${dir} ${archive_dir}
done

find ${archive_dir} \
  -mindepth 1 \
  -maxdepth 1 \
  -type d \
  -exec echo ln -sf {} . \;
