#/bin/bash

VERSION=v$(date -u +%Y%m%d-%H%M%S)
echo $VERSION
VERSION=v0.3

docker build \
  -f Dockerfile \
  -t wpafbo79/invokeai:$VERSION \
  -t wpafbo79/invokeai:latest \
  .

time ( \
  docker push wpafbo79/invokeai:$VERSION && \
  docker push wpafbo79/invokeai:latest \
)