#/bin/bash

CUDA_VERSION=$(grep "ENV CUDA_VERSION" Dockerfile | cut -d '=' -f 2)
MINICONDA3_VERSION=$(grep "ENV MINICONDA3_VERSION" Dockerfile | cut -d '=' -f 2)
TINI_VERSION=$(grep "ENV TINI_VERSION" Dockerfile | cut -d '=' -f 2)

VERSION=cuda-${CUDA_VERSION}
VERSION=${VERSION}_miniconda3-${MINICONDA3_VERSION}
VERSION=${VERSION}_tini-${TINI_VERSION}

echo $VERSION

docker build \
  -f Dockerfile \
  -t wpafbo79/mini-cuda:$VERSION \
  -t wpafbo79/mini-cuda:latest \
  .

time ( \
  docker push wpafbo79/mini-cuda:$VERSION && \
  docker push wpafbo79/mini-cuda:latest \
)
