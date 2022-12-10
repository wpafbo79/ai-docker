# syntax=docker/dockerfile:1

FROM wpafbo79/mini-cuda-with-prereqs:latest

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}stable-diffusion/"

# Build variables.
ARG GIT_REPO

# Download Stable Diffusion git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 "${GIT_REPO}"

# Configure conda.
WORKDIR $INSTALL_DIR
RUN conda env create -f environment.yaml \
 && conda init bash \
 && conda clean --all --yes

# Do initial setup (licensed models not are downloaded).
RUN conda init bash \
 && conda activate ldm

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
ADD start.sh .
RUN dos2unix start.sh \
 && chmod +x start.sh

ENTRYPOINT ${INSTALL_DIR}/start.sh
