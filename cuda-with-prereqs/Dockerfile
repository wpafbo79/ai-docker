# syntax=docker/dockerfile:1

FROM nvidia/cuda:12.0.0-base-ubuntu22.04
ENV CUDA_VERSION=12.0.0

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"

# Install pre-reqs.
RUN apt-get update \
 && apt-get install -y \
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
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

################################################################################
# Reference Tini project page:
#   https://github.com/krallin/tini
ENV TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT [ "/tini", "--" ]
CMD [ "/bin/bash" ]
