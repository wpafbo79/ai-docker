REPO="wpafbo79/gfpgan"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="gfpgan"

PORT_MAP="none"

INSTALL_DIR="/GFPGAN/"

declare -A VOLUMES
VOLUMES[i]="inputs:${INSTALL_DIR}inputs/"
VOLUMES[e]="experiments:${INSTALL_DIR}experiments/"
VOLUMES[r]="results:${INSTALL_DIR}results/"
