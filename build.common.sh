#/bin/bash

declare do_build=0

function build() {
  : ${GIT_COMMIT:=}
  : ${GIT_REPO:=}

  echo ${DOCKER_REPO}:${VERSION}

  check_checksums

  touch .prevdigest

  grep FROM Dockerfile | cut -d " " -f 2
  docker pull $(grep FROM Dockerfile | cut -d " " -f 2)

  prevdigest=$(cat .prevdigest)
  currdigest=$(docker image ls --digests |
    grep -E $(grep FROM Dockerfile |
      cut -d " " -f 2 |
      sed -e 's/:/\\s\*/') |
    awk  '{print $3}')

  if [ "${prevdigest}" != "${currdigest}" ]; then
    do_build=1
  fi

  if [ ${do_build} -eq 0 ]; then
    echo "No changes.  Skipping build."

    docker pull ${DOCKER_REPO}:${VERSION}
    docker tag ${DOCKER_REPO}:${VERSION} ${DOCKER_REPO}:latest
  else
    docker build \
      --no-cache \
      --progress=plain \
      --build-arg GIT_COMMIT="${GIT_COMMIT}" \
      --build-arg GIT_REPO="${GIT_REPO}" \
      -f Dockerfile \
      -t ${DOCKER_REPO}:${VERSION} \
      -t ${DOCKER_REPO}:latest \
      . 2>&1 |
    tee log.${VERSION}
  fi

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
      echo docker push ${DOCKER_REPO}:${VERSION} &&
      docker push ${DOCKER_REPO}:${VERSION} &&
      echo docker push ${DOCKER_REPO}:latest &&
      docker push ${DOCKER_REPO}:latest
    )
  # Delete the image if it is a new version for an existing image (e.g. there is
  # both a "latest" and versioned label)
  elif [ $(docker image ls | grep ${currid} | wc -l) -gt 2 ]; then
    echo "Removing ${DOCKER_REPO}:${VERSION}..."
    docker image rm ${DOCKER_REPO}:${VERSION}
  fi

  echo ${currdigest} > .prevdigest
  echo ${currid} > .previd

  create_checksums
}

function check_checksums() {
  echo "Checking checksums..."

  for file in *; do
    if [ "${file##*.}" == "md5" -o "${file%%.*}" == "log" -o -d ${file} ]; then
      continue
    fi


    md5=.${file}.md5
    touch ${md5}

    $(diff <(cat ${md5}) <(md5sum ${file}) 2>&1 >/dev/null) ||
      { echo "Detected change: ${file}" && do_build=1; }
  done
}

function create_checksums() {
  for file in *; do
    if [ "${file##*.}" == "md5" -o "${file%%.*}" == "log" -o -d ${file} ]; then
      continue
    fi

    md5=.${file}.md5

    md5sum ${file} > ${md5}
  done
}
