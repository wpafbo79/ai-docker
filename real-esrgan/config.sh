REPO="wpafbo79/real-esrgan"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="real-esrgan"

PORT_MAP="none"

INSTALL_DIR="/Real-ESRGAN/"

declare -A VOLUMES
VOLUMES[i]="inputs:${INSTALL_DIR}inputs/"
VOLUMES[e]="experiments:${INSTALL_DIR}experiments/"
VOLUMES[r]="results:${INSTALL_DIR}results/"
VOLUMES[w]="weights:${INSTALL_DIR}weights/"
