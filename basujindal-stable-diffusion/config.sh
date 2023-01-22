DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="basujindal-stable-diffusion"

DOCKER_REPO="wpafbo79/basujindal-stable-diffusion"

GIT_COMMIT="54b4a91633e38f6060d29c4e0194efe8f66eeedc"
GIT_REPO="https://github.com/basujindal/stable-diffusion.git"

INSTALL_DIR="/stable-diffusion/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="7860:7860"

VERSION="${GIT_COMMIT:0:7}"

declare -A VOLUMES
# Don't use: b, h, n, v
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[s]="models-stable-diffusion:${INSTALL_DIR}models/ldm/stable-diffusion-v1/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
