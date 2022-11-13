# syntax=docker/dockerfile:1

FROM wpafbo79/mini-cuda:latest

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}stable-diffusion/"

# Install pre-reqs.
RUN apt update \
 && apt install -y \
    dos2unix \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    --no-install-recommends \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && conda update -n base -c defaults conda \
 && conda clean --all --yes

# Download Stable Diffusion git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 https://github.com/basujindal/stable-diffusion.git

# Configure conda.
WORKDIR $INSTALL_DIR
RUN conda env create -f environment.yaml \
 && conda init bash \
 && conda clean --all --yes

# Do initial setup (licensed models not are downloaded).
RUN conda init bash \
 && conda activate ldm

# Make existing data available to volumes.
ENV ARCHIVE_DIR="${INSTALL_DIR}archive/"
ENV CONFIGS_DIR="${INSTALL_DIR}configs/"
ENV LOGS_DIR="${INSTALL_DIR}logs/"
#ENV MODELS_DIR="${INSTALL_DIR}models/ldm/stable-diffusion-v1/"
ENV MODELS_DIR="${INSTALL_DIR}models/"
ENV OUTPUTS_DIR="${INSTALL_DIR}outputs/"
ENV TRAINING_DIR="${INSTALL_DIR}training-data/"

RUN mkdir -p \
    ${ARCHIVE_DIR} \
    ${CONFIGS_DIR} \
    ${LOGS_DIR}  \
    ${MODELS_DIR}  \
    ${OUTPUTS_DIR}  \
    ${TRAINING_DIR} \
 && mv ${CONFIGS_DIR} ${ARCHIVE_DIR} \
 && mv ${LOGS_DIR} ${ARCHIVE_DIR} \
 && mv ${MODELS_DIR} ${ARCHIVE_DIR} \
 && mv ${OUTPUTS_DIR} ${ARCHIVE_DIR} \
 && mv ${TRAINING_DIR} ${ARCHIVE_DIR} \
 && find ${ARCHIVE_DIR} \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -exec echo ln -sf {} . \;

# Install rsync for start.sh to copy files from the archive.
RUN apt update \
 && apt install -y \
    rsync \
    --no-install-recommends \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Entry point.
ADD start.sh .
RUN dos2unix start.sh \
 && chmod +x start.sh

ENTRYPOINT ${INSTALL_DIR}/start.sh
