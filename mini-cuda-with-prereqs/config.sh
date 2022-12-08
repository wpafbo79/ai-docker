DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="mini-cuda-with-prereqs"

REPO="wpafbo79/${DEFAULT_NAME}"

VERSION=$(grep FROM Dockerfile | cut -d ":" -f 2)
