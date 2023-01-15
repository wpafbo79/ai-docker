# syntax=docker/dockerfile:1

FROM wpafbo79/cuda-with-prereqs:latest

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}GFPGAN/"

# Build variables
ARG GIT_REPO

# Download Stable Diffusion git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 "${GIT_REPO}"

# Install requirements and setup.
WORKDIR $INSTALL_DIR
RUN pip install basicsr
RUN pip install facexlib
RUN pip install -r requirements.txt
RUN python setup.py develop
RUN pip install realesrgan

# Add initial model.
RUN mkdir -p experiments/pretrained_models/
ADD https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth \
    experiments/pretrained_models/

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

ENTRYPOINT ${INSTALL_DIR}/start.sh
