#/bin/bash

function build() {
  echo $REPO:$VERSION

  docker build \
    -f Dockerfile \
    -t $REPO:$VERSION \
    -t $REPO:latest \
    .

  touch .previd

  previd=$(cat .previd)
  currid=$(docker image ls |
    grep mini-cuda |
    grep latest |
    tr -s " " |
    cut -d " " -f 3)

  # Push the image if it is new
  if [ "$previd" != "$currid" ]; then
    time ( \
      docker push $REPO:$VERSION && \
      docker push $REPO:latest \
    )
  # Delete the image if it is a new version for an existing image (e.g. there is
  # both a "latest" and versioned label)
  elif [ $(docker image ls | grep $currid | wc -l) -gt 2 ]; then
    docker image rm $REPO:$VERSION
  fi

  echo $currid > .previd
}
