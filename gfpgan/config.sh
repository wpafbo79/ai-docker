DEFAULT_NAME="gfpgan"

DOCKER_REPO="wpafbo79/gfpgan"

GIT_REPO="https://github.com/TencentARC/GFPGAN.git"

INSTALL_DIR="/GFPGAN/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="none"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

CREATE_VERSION="${VERSION}"

declare -A VOLUMES
# Don't use: b, h, n, v
VOLUMES[i]="inputs:${INSTALL_DIR}inputs/"
VOLUMES[e]="experiments:${INSTALL_DIR}experiments/"
VOLUMES[r]="results:${INSTALL_DIR}results/"
