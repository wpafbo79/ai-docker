REPO="wpafbo79/compvis-stable-diffusion"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="compviz-stable-diffusion"

PORT_MAP="none"

INSTALL_DIR="/stable-diffusion/"

declare -A VOLUMES
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[m]="models:${INSTALL_DIR}models/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
