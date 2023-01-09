DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="invokeai"

DOCKER_REPO="wpafbo79/invokeai"

GIT_REPO="https://github.com/invoke-ai/InvokeAI.git"

INSTALL_DIR="/InvokeAI/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="9090:9090"

VERSION="v$(date -u +%Y%m%d-%H%M%S)"

declare -A VOLUMES
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[m]="models:${INSTALL_DIR}models/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
