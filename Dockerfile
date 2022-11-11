# syntax=docker/dockerfile:1
 
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

################################################################################
# Reference miniconda dockerfile:
#   https://hub.docker.com/r/continuumio/miniconda3/dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

#ENTRYPOINT [ "/usr/bin/tini", "--" ]
#CMD [ "/bin/bash" ]

################################################################################
# Start InvokeAI layers

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}InvokeAI/"

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

# Download InvokeAI git repo.
WORKDIR $BASE_DIR
RUN git clone --depth=1 https://github.com/invoke-ai/InvokeAI.git

# Configure conda.
WORKDIR $INSTALL_DIR
RUN conda env create \
 && conda init bash \
 && conda clean --all --yes

# Do initial setup (licensed models not are downloaded).
RUN conda init bash \
 && conda activate invokeai \
 && python3 scripts/preload_models.py --no-interactive

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

# Ports.
EXPOSE 9090

# Volumes no longer defined here since they can be used anyway.

ENTRYPOINT ${INSTALL_DIR}/start.sh