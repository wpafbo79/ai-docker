DEFAULT_NAME="cuda-cudnn-with-prereqs-and-tensorrt"

DOCKER_REPO="wpafbo79/${DEFAULT_NAME}"

CUDA_VERSION=$(grep "ENV CUDA_VERSION" Dockerfile | cut -d '=' -f 2)
CUDNN_VERSION=$(grep "ENV CUDNN_VERSION" Dockerfile | cut -d '=' -f 2)
TINI_VERSION=$(grep "ENV TINI_VERSION" Dockerfile | cut -d '=' -f 2)

VERSION="cuda-${CUDA_VERSION}"
VERSION="${VERSION}-cudnn${CUDNN_VERSION}"
VERSION="${VERSION}_tini-${TINI_VERSION}"

CREATE_VERSION="${VERSION}"
