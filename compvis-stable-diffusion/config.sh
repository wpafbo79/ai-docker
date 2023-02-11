DEFAULT_NAME="compviz-stable-diffusion"

DOCKER_REPO="wpafbo79/compvis-stable-diffusion"

GIT_COMMIT="21f890f9da3cfbeaba8e2ac3c425ee9e998d5229"
GIT_REPO="https://github.com/CompVis/stable-diffusion.git"

INSTALL_DIR="/stable-diffusion/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="none"

VERSION="${GIT_COMMIT:0:7}"

CREATE_VERSION="${VERSION}"

declare -A VOLUMES
# Don't use: b, h, n, v
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[s]="models-stable-diffusion:${INSTALL_DIR}models/ldm/stable-diffusion-v1/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
