# syntax=docker/dockerfile:1
 
FROM continuumio/miniconda3
SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}InvokeAI/"

ENV CONFIGS_DIR="${INSTALL_DIR}configs/"
ENV MODELS_DIR="${INSTALL_DIR}models/ldm/stable-diffusion-v1/"
ENV OUTPUTS_DIR="${INSTALL_DIR}outputs/"
ENV TRAINING_DIR="${INSTALL_DIR}training-data/"

# Install pre-reqs.
RUN apt update \
 && apt install -y \
    dos2unix \
    git \
    libgl1 \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 && conda update -n base -c defaults conda \
 && conda clean --all --yes

# Download InvokeAI git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 https://github.com/invoke-ai/InvokeAI.git

# Configure conda.
WORKDIR $INSTALL_DIR
RUN conda env create \
 && conda init bash \
 && conda clean --all --yes

# Initial setup sans models
RUN python3 scripts/preload_models.py --no-interactive

# Entry point.
ADD start.sh .
RUN dos2unix start.sh \
 && chmod +x start.sh \
 && mkdir -p outputs/ training-data

# Ports and Volumes.
EXPOSE 9090
VOLUME ["${CONFIGS_DIR}", "${MODELS_DIR}", "${OUTPUTS_DIR}", "${TRAINING_DIR}"]

ENTRYPOINT ${INSTALL_DIR}/start.sh
