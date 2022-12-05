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
RUN git clone --depth=1 https://github.com/CompVis/stable-diffusion.git

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
