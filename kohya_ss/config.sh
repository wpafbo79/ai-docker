DEFAULT_NAME="kohya_ss"

DOCKER_REPO="wpafbo79/${DEFAULT_NAME}"

GIT_COMMIT="v21.2.5"
GIT_REPO="https://github.com/bmaltais/kohya_ss.git"

INSTALL_DIR="/kohya_ss/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="7680:7680"

VERSION="${GIT_COMMIT}"

CREATE_VERSION="${VERSION}"

declare -A VOLUMES
# Don't use: b, h, n, v
VOLUMES[d]="models-diffusers:/root/.cache/huggingface/diffusers/"
VOLUMES[e]="embeddings:${INSTALL_DIR}embeddings/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
