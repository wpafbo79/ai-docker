#/bin/bash

function build() {
  echo ${DOCKER_REPO}:${VERSION}

  docker build \
    --no-cache \
    -f Dockerfile \
    -t ${DOCKER_REPO}:${VERSION} \
    -t ${DOCKER_REPO}:latest \
    .

  touch .previd

  previd=$(cat .previd)
  currid=$(docker image ls |
    grep ${DOCKER_REPO} |
    grep latest |
    tr -s " " |
    cut -d " " -f 3)

  # Push the image if it is new
  if [ "${previd}" != "${currid}" ]; then
    echo "Uploading..."
    time ( \
      docker push ${DOCKER_REPO}:${VERSION} && \
      docker push ${DOCKER_REPO}:latest \
    )
  # Delete the image if it is a new version for an existing image (e.g. there is
  # both a "latest" and versioned label)
  elif [ $(docker image ls | grep ${currid} | wc -l) -gt 2 ]; then
    echo "Removing ${DOCKER_REPO}:${VERSION}..."
    docker image rm ${DOCKER_REPO}:${VERSION}
  fi

  echo ${currid} > .previd
}
