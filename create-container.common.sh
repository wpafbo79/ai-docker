#!/bin/bash

progname=$(basename $0)

declare -A VOLUMES

function create-container() {
  declare -A optVolumes
  declare -a volumes

  optBase=""
  optName=${DEFAULT_NAME}
  optVersion=${DEFAULT_CREATE_VERSION}
  optVolumesUsed="false"

  while getopts $(optionstring ":b:hn:v:") options; do
    case "${options}" in
      b)
        optBase=${OPTARG}
        ;;
      h)
        usage "${DEFAULT_NAME}" "${DEFAULT_CREATE_VERSION}"
        ;;
      n)
        optName=${OPTARG}
        ;;
      v)
        optVersion=${OPTARG}
        ;;
      *)
        if [ "${VOLUMES[${options}]+yes}" = "yes" ]; then
          optVolumes[${options}]=${OPTARG}

          optVolumesUsed="true"
        else
          usage "${DEFAULT_NAME}" "${DEFAULT_CREATE_VERSION}"

          exit 1
        fi
        ;;
    esac
  done
  shift $((OPTIND-1))

  if [ "${optBase}" != "" -a ${optVolumesUsed} = "true" ]; then
    usage "${DEFAULT_NAME}" "${DEFAULT_CREATE_VERSION}"
  fi

  if [ "${optBase}" != "" ]; then
    for opt in ${!VOLUMES[@]}; do
      vol=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 1)

      optVolumes[${opt}]="${optBase}/${vol}/"
    done
  fi

  for opt in ${!VOLUMES[@]}; do
    dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)

    if [ "${optVolumes[${opt}]+yes}" = "yes" ]; then
      volumes+=(${optVolumes[${opt}]}:${dir})
    fi
  done

  portmap=$(echo ${PORT_MAP} | xargs) # Strip off whitespace

  if [ "${portmap}" != "none" -a "${portmap}" != "" ]; then
    portmap="-p ${portmap}"
  else
    portmap=""
  fi

  for i in ${!volumes[@]}; do
    volumes[${i}]="-v ${volumes[${i}]}"
  done

  docker pull ${DOCKER_REPO}:${optVersion}

  docker run \
    --gpus all \
    --name ${optName} \
    -d \
    ${portmap} \
    ${volumes[@]} \
    ${DOCKER_REPO}:${optVersion}
}

function optionstring() {
  str=$1

  for opt in ${!VOLUMES[@]}; do
    str="${str}${opt}:"
  done

  echo ${str}
}

function usage() {
  name=$1
  version=$2

  usage="
Usage: ${progname} [-h] [-n <name>] [-v <versiontag>] [-b <basedir> |
$(for opt in ${!VOLUMES[@]}; do
    vol=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 1)
    cat <<EOF
         -${opt} <${vol}dir>
EOF
  done |
  sort |
  sed -e 's/:/:\n        /'
)
       ]

  -b  Base directory that contains directories:
$(for opt in ${!VOLUMES[@]}; do
    vol=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 1)
    cat <<EOF
        ${vol}/
EOF
  done |
  sort
)
  -h  Show this usage statement.
  -n  Name for the container.  [Default:\"${name}\"]
  -v  The version tag to use to create the container.  [Default:\"${version}\"]

  Volume options:
$(for opt in ${!VOLUMES[@]}; do
    dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)
    cat <<EOF
  -${opt}  The local directory to mount to:${dir}
EOF
  done |
  sort |
  sed -e 's/:/:\n        /'
)

  Volumes used by this container:
$(for opt in ${!VOLUMES[@]}; do
    vol=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 1)
    dir=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 2)
    cat <<EOF
    - ${vol}:${dir}
EOF
  done |
  sort
)
"

  echo "${usage}" 1>&2

  exit 1
}
