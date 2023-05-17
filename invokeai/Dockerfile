# syntax=docker/dockerfile:1
 
FROM wpafbo79/cuda-with-prereqs:cuda-12.0.0_tini-0.19.0

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}InvokeAI/"

# Build variables.
ARG GIT_COMMIT
ARG GIT_REPO

# Download InvokeAI git repo.
WORKDIR ${BASE_DIR}
#RUN git clone --depth=1 "${GIT_REPO}"
RUN mkdir -p ${INSTALL_DIR}
WORKDIR ${INSTALL_DIR}
RUN git init \
 && git remote add origin "${GIT_REPO}" \
 && git fetch --depth 1 origin "${GIT_COMMIT}" \
 && git checkout FETCH_HEAD

# Configure virtual environment.
WORKDIR ${INSTALL_DIR}
RUN python3 -m venv /.venv \
    --upgrade-deps \
    --copies \
 && source /.venv/bin/activate \
 && python3 -m pip install --upgrade pip \
 && pip install --use-pep517 .

# Build patchmatch
RUN apt-get update \
 && apt-get install -y \
    build-essential \
    python3-opencv \
    libopencv-dev \
    --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN source /.venv/bin/activate \
 && pip install pypatchmatch \
 && python3 -c "from patchmatch import patch_match"

# Do initial setup (licensed models are not downloaded).
RUN source /.venv/bin/activate \
 && invokeai-configure --root=$(pwd) --skip-sd-weights --yes

# Make existing data available to volumes.
ADD archive.sh .
ADD config.sh .
RUN dos2unix archive.sh \
 && chmod +x archive.sh \
 && ./archive.sh

# Install rsync for start.sh to copy files from the archive.
RUN apt-get update \
 && apt-get install -y \
    rsync \
    --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entry point.
ADD sync-archive.sh .
ADD start.sh .
RUN dos2unix start.sh \
 && chmod +x start.sh

# Ports.
EXPOSE 9090

ENTRYPOINT ${INSTALL_DIR}/start.sh
