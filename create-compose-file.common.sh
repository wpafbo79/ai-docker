#!/bin/bash

progname=$(basename $0)

declare -A VOLUMES

function create-compose-file() {
  declare -A optVolumes
  declare -a volumes

  cat << EOF
version: "3"

services:
  app:
    image: ${DOCKER_REPO}:${DEFAULT_CREATE_VERSION}
    restart: unless-stopped
EOF
  if [ -v VOLUMES[@] ]; then
    cat << EOF
    volumes:
EOF

    for opt in ${!VOLUMES[@]}; do
      echo "      - ${VOLUMES[${opt}]}"
    done
  fi

  cat << EOF
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
EOF

  if [ -v VOLUMES[@] ]; then
    cat << EOF

volumes:
EOF

    for opt in ${!VOLUMES[@]}; do
      volume=$(echo ${VOLUMES[${opt}]} | cut -d ":" -f 1)
      echo "  ${volume}:"
      echo "    driver: local"
    done
  fi
}
