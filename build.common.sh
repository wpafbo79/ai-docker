#/bin/bash

function build() {
  echo ${REPO}:${VERSION}

  docker build \
    --no-cache \
    -f Dockerfile \
    -t ${REPO}:${VERSION} \
    -t ${REPO}:latest \
    .

  touch .previd

  previd=$(cat .previd)
  currid=$(docker image ls |
    grep ${REPO} |
    grep latest |
    tr -s " " |
    cut -d " " -f 3)

exit
echo ${previd}
echo ${currid}
docker image ls | grep ${currid}
  # Push the image if it is new
  if [ "${previd}" != "${currid}" ]; then
    echo "Uploading..."
    time ( \
      docker push ${REPO}:${VERSION} && \
      docker push ${REPO}:latest \
    )
  # Delete the image if it is a new version for an existing image (e.g. there is
  # both a "latest" and versioned label)
  elif [ $(docker image ls | grep ${currid} | wc -l) -gt 2 ]; then
    echo "Removing ${REPO}:${VERSION}..."
    docker image rm ${REPO}:${VERSION}
  fi

  echo ${currid} > .previd
}
