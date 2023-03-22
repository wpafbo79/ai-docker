# syntax=docker/dockerfile:1

FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04
ENV CUDA_VERSION=11.6.2
ENV CUDNN_VERSION=8

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV CUDA_HOME="/usr/local/cuda/"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64/:/usr/local/cuda/include/"

# Install pre-reqs and upgrade to Python 3.10
RUN apt-get update --fix-missing \
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
    python3-dev \
    python3-pip \
    python3-tk \
    python3-venv \
    wget \
    --no-install-recommends \
 && apt-get install -y \
    software-properties-common \
    --no-install-recommends \
 && add-apt-repository -y ppa:deadsnakes/ppa \
 && apt-get update --fix-missing \
 && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3.10-tk \
    python3.10-venv \
    --no-install-recommends \
 && update-alternatives --install /usr/bin/python python $(which python3.8) 1 \
 && update-alternatives --install /usr/bin/python python $(which python3.10) 2 \
 && update-alternatives --set python $(which python3.10) \
 && update-alternatives --config python \
 && update-alternatives --install /usr/bin/python3 python3 $(which python3.8) 1 \
 && update-alternatives --install /usr/bin/python3 python3 $(which python3.10) 2 \
 && update-alternatives --set python3 $(which python3.10) \
 && update-alternatives --config python3 \
 && python3 -m ensurepip --upgrade \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Configure virtual environment.
RUN python -m venv /.venv \
    --copies \
    --upgrade-deps \
 && python3 -m venv /.venv \
    --copies \
    --upgrade-deps \
 && source /.venv/bin/activate \
 && python3 -m pip install --upgrade pip

################################################################################
# Reference Tini project page:
#   https://github.com/krallin/tini
ENV TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT [ "/tini", "--" ]
CMD [ "/bin/bash" ]
