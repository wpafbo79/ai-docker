# syntax=docker/dockerfile:1

FROM wpafbo79/mini-cuda-base:cuda-11.8.0_miniconda3-4.5.12_tini-0.19.0

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Install pre-reqs.
RUN apt-get update \
 && apt-get install -y \
    dos2unix \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && conda update -n base -c defaults conda \
 && conda clean --all --yes
