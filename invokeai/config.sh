DEFAULT_CREATE_VERSION="latest"
DEFAULT_NAME="invokeai"

DOCKER_REPO="wpafbo79/invokeai"

GIT_COMMIT="v2.2.5p2"
GIT_REPO="https://github.com/invoke-ai/InvokeAI.git"

INSTALL_DIR="/InvokeAI/"

ARCHIVE_DIR="${INSTALL_DIR}archive/"

PORT_MAP="9090:9090"

VERSION="${GIT_COMMIT}"

declare -A VOLUMES
# Don't use: b, h, n, v
VOLUMES[c]="configs:${INSTALL_DIR}configs/"
VOLUMES[e]="embeddings:${INSTALL_DIR}embeddings/"
VOLUMES[f]="codeformer:${INSTALL_DIR}models/codeformer/"
VOLUMES[g]="models-gfpgan:${INSTALL_DIR}models/gfpgan/"
VOLUMES[l]="logs:${INSTALL_DIR}logs/"
VOLUMES[o]="outputs:${INSTALL_DIR}outputs/"
VOLUMES[r]="models-real-esrgan:${INSTALL_DIR}models/realesrgan/"
VOLUMES[s]="models-stable-diffusion:${INSTALL_DIR}models/ldm/stable-diffusion-v1/"
VOLUMES[t]="training-data:${INSTALL_DIR}training-data/"
