DEFAULT_NAME="cuda-with-prereqs"

DOCKER_REPO="wpafbo79/${DEFAULT_NAME}"

CUDA_VERSION=$(grep "ENV CUDA_VERSION" Dockerfile | cut -d '=' -f 2)
TINI_VERSION=$(grep "ENV TINI_VERSION" Dockerfile | cut -d '=' -f 2)

VERSION="cuda-${CUDA_VERSION}"
VERSION="${VERSION}_tini-${TINI_VERSION}"

CREATE_VERSION="${VERSION}"
