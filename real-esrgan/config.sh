DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="real-esrgan"

DOCKER_REPO="wpafbo79/real-esrgan"

INSTALL_DIR="/Real-ESRGAN/"

PORT_MAP="none"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

declare -A VOLUMES
VOLUMES[i]="inputs:${INSTALL_DIR}inputs/"
VOLUMES[e]="experiments:${INSTALL_DIR}experiments/"
VOLUMES[r]="results:${INSTALL_DIR}results/"
VOLUMES[w]="weights:${INSTALL_DIR}weights/"
