#/bin/bash

VERSION=v$(date -u +%Y%m%d-%H%M%S)

echo $VERSION

docker build \
  -f Dockerfile \
  -t wpafbo79/gfpgan:$VERSION \
  -t wpafbo79/gfpgan:latest \
  .

time ( \
  docker push wpafbo79/gfpgan:$VERSION && \
  docker push wpafbo79/gfpgan:latest \
)
