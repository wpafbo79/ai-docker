DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="basujindal-stable-diffusion"

DOCKER_REPO="wpafbo79/basujindal-stable-diffusion"

GIT_REPO="https://github.com/basujindal/stable-diffusion.git"

INSTALL_DIR="/stable-diffusion/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="none"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

declare -A VOLUMES
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[m]="models:${INSTALL_DIR}models/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
