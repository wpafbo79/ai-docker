DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="compviz-stable-diffusion"

DOCKER_REPO="wpafbo79/compvis-stable-diffusion"

INSTALL_DIR="/stable-diffusion/"

PORT_MAP="none"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

declare -A VOLUMES
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[m]="models:${INSTALL_DIR}models/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
