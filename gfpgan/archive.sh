#!/bin/bash

source config.sh

archive_dir="${INSTALL_DIR}archive/"

mkdir -p ${archive_dir}

for opt in ${!VOLUMES[@]}; do
  dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)

  basedir=$(dirname ${dir})
  leaf=$(basename ${dir} /)

  mkdir -p ${dir}
  mv ${dir} ${archive_dir}
  ln -sf ${archive_dir}/${leaf}/ ${basedir}
done
