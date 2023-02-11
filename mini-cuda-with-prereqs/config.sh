DEFAULT_NAME="mini-cuda-with-prereqs"

DOCKER_REPO="wpafbo79/${DEFAULT_NAME}"

VERSION=$(grep FROM Dockerfile | cut -d ":" -f 2)

CREATE_VERSION="${VERSION}"
