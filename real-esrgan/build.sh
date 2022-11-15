#/bin/bash

VERSION=v$(date -u +%Y%m%d-%H%M%S)

echo $VERSION

docker build \
  -f Dockerfile \
  -t wpafbo79/real-esrgan:$VERSION \
  -t wpafbo79/real-esrgan:latest \
  .

time ( \
  docker push wpafbo79/real-esrgan:$VERSION && \
  docker push wpafbo79/real-esrgan:latest \
)
