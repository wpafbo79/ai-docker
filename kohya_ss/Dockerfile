# syntax=docker/dockerfile:1

FROM wpafbo79/cuda-cudnn-with-prereqs-and-tensorrt:cuda-11.6.2-cudnn8_tini-0.19.0

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}kohya_ss/"

# Build variables
ARG GIT_COMMIT
ARG GIT_REPO

# Kohya variables
ENV ACCELERATE=False
ENV FORCE_CUDA=1
ENV TENSORRT_PATH=/.venv/lib/python3.8/site-packages/tensorrt/
ENV TF_ENABLE_ONEDNN_OPTS=1

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TENSORRT_PATH}"

# Install accelerate config.
RUN mkdir -p /root/.cache/huggingface/accelerate/
WORKDIR /root/.cache/huggingface/accelerate/
ADD default_config.yaml .

# Download Stable Diffusion git repo.
WORKDIR ${BASE_DIR}
#RUN git clone --depth=1 "${GIT_REPO}"
RUN mkdir -p ${INSTALL_DIR}
WORKDIR ${INSTALL_DIR}
RUN git init \
 && git remote add origin "${GIT_REPO}" \
 && git fetch --depth 1 origin "${GIT_COMMIT}" \
 && git checkout FETCH_HEAD

# Install requirements
RUN apt-get update --fix-missing \
 && apt-get install -y \
    curl \
    --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Configure virtual environment.
WORKDIR ${INSTALL_DIR}
RUN python3 -m venv /.venv \
    --copies \
    --upgrade-deps \
 && source /.venv/bin/activate \
 && python3 -m pip install --upgrade pip \
 && python3 -m pip install \
    ninja \
 && rm -rf /tmp/pip-install*

# Create missing directories from Cuda image and venv.
RUN mkdir -p \
    /usr/local/nvidia/lib \
    /usr/local/nvidia/lib64 \
    /.venv/lib/python3.10/lib64

# Do Linux setup
RUN cat /dev/null > requirements.cu116 \
 && echo "torch==1.13.1+cu116" >> requirements.cu116 \
 && echo "torchvision==0.14.1+cu116" >> requirements.cu116 \
 && sed \
    -e 's/sudo \(.*\)/\1/' \
    -e 's/apt /apt-get /' \
    -e '/-m venv/d' \
    -e 's/\(source\) venv/\1 \/.venv/' \
    -e 's/pip install/python -m pip install/' \
    -e '/torch==/d' \
    -e '/torchvision==/d' \
    -e 's/\(--upgrade\)/\1 --extra-index-url https:\/\/download.pytorch.org\/whl\/cu116/' \
    -e 's/.*xformers.*/python -m pip install xformers==0.0.16/' \
    -e 's/\(accelerate config\).*/\1 default/' \
    ./ubuntu_setup.sh \
    -i \
 && mv requirements.txt requirements.req \
 && cat requirements.cu116 requirements.req > requirements.txt \
 && rm -f requirements.cu116 requirements.req \
 && mkdir -p ${TENSORRT_PATH} \
 && ln -sf ${TENSORRT_PATH}libnvinfer.so.{8,7} \
 && ln -sf ${TENSORRT_PATH}libnvinfer_plugin.so.{8,7} \
 && ./ubuntu_setup.sh \
 && rm -rf /tmp/pip-install*

# Make existing data available to volumes.
ADD archive.sh .
ADD config.sh .
RUN dos2unix archive.sh \
 && chmod +x archive.sh \
 && ./archive.sh

# Install rsync for start.sh to copy files from the archive.
RUN apt-get update --fix-missing \
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

# Ports.
# Tensorboard
EXPOSE 6006
# Kohya
EXPOSE 7680

ENTRYPOINT ${INSTALL_DIR}/start.sh
