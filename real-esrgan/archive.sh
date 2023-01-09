#!/bin/bash

source config.sh

mkdir -p ${ARCHIVE_DIR}

for opt in ${!VOLUMES[@]}; do
  dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)

  basedir=$(dirname ${dir})
  leaf=$(basename ${dir} /)

  mkdir -p ${dir}
  mv ${dir} ${ARCHIVE_DIR}
  ln -sf ${ARCHIVE_DIR}/${leaf}/ ${basedir}
done
