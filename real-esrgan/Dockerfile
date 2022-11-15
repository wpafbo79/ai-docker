# syntax=docker/dockerfile:1

FROM nvidia/cuda:11.8.0-base-ubuntu22.04

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}Real-ESRGAN/"

# Install pre-reqs.
RUN apt update \
 && apt install -y \
    dos2unix \
    git \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    python-is-python3 \
    python3 \
    python3-pip \
    wget \
    --no-install-recommends \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Download Stable Diffusion git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 https://github.com/xinntao/Real-ESRGAN

# Install requirements and setup.
WORKDIR $INSTALL_DIR
RUN pip install basicsr
RUN pip install facexlib
RUN pip install gfpgan
RUN pip install -r requirements.txt
RUN python setup.py develop

# Make existing data available to volumes.
ENV ARCHIVE_DIR="${INSTALL_DIR}archive/"
ENV INPUTS_DIR="${INSTALL_DIR}inputs/"
ENV MODELS_DIR="${INSTALL_DIR}experiments/"
ENV RESULTS_DIR="${INSTALL_DIR}results/"
ENV WEIGHTS_DIR="${INSTALL_DIR}weights/"

RUN mkdir -p \
    ${ARCHIVE_DIR} \
    ${INPUTS_DIR}  \
    ${MODELS_DIR}  \
    ${RESULTS_DIR}  \
    ${WEIGHTS_DIR}  \
 && mv ${INPUTS_DIR} ${ARCHIVE_DIR} \
 && mv ${MODELS_DIR} ${ARCHIVE_DIR} \
 && mv ${RESULTS_DIR} ${ARCHIVE_DIR} \
 && mv ${WEIGHTS_DIR} ${ARCHIVE_DIR} \
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
