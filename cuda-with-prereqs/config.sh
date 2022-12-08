DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="cuda-with-prereqs"

REPO="wpafbo79/${DEFAULT_NAME}"

CUDA_VERSION=$(grep "ENV CUDA_VERSION" Dockerfile | cut -d '=' -f 2)
TINI_VERSION=$(grep "ENV TINI_VERSION" Dockerfile | cut -d '=' -f 2)

VERSION="cuda-${CUDA_VERSION}"
VERSION="${VERSION}_tini-${TINI_VERSION}"
