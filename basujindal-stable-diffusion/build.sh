#/bin/bash

VERSION=v$(date -u +%Y%m%d-%H%M%S)

echo $VERSION

docker build \
  -f Dockerfile \
  -t wpafbo79/basujindal-stable-diffusion:$VERSION \
  -t wpafbo79/basujindal-stable-diffusion:latest \
  .

time ( \
  docker push wpafbo79/basujindal-stable-diffusion:$VERSION && \
  docker push wpafbo79/basujindal-stable-diffusion:latest \
)
