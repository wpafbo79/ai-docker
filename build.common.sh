#/bin/bash

function build() {
  echo ${DOCKER_REPO}:${VERSION}

  DOCKER_BUILDKIT=0 \
  docker build \
    --no-cache \
    --progress=plain \
    --build-arg GIT_REPO="${GIT_REPO}" \
    -f Dockerfile \
    -t ${DOCKER_REPO}:${VERSION} \
    -t ${DOCKER_REPO}:latest \
    . 2>&1 |
  tee log.${VERSION}

  touch .previd

  previd=$(cat .previd)
  currid=$(docker image ls |
    grep ${DOCKER_REPO} |
    grep latest |
    tr -s " " |
    cut -d " " -f 3)

  # Push the image if it is new
  if [ -f ../.nopublish -o -f .nopublish ]; then
    echo "\".nopublish\" detected.  Skipping upload to Docker repo."
  elif [ "${previd}" != "${currid}" ]; then
    echo "Uploading..."
    cat << EOF
Bypass publishing to the Docker repo by creating ".nopublish" in the root
directory of the repo.  If created in a subdirectory, only that image will be
skipped.
EOF
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
