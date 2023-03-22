# syntax=docker/dockerfile:1

FROM wpafbo79/cuda-cudnn-with-prereqs:cuda-11.6.2-cudnn8_tini-0.19.0
ENV CUDA_VERSION=11.6.2
ENV CUDNN_VERSION=8
ENV TINI_VERSION=0.19.0

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"

# Configure virtual environment and install TensorRT.
RUN python3 -m venv /.venv \
    --copies \
    --upgrade-deps \
 && source /.venv/bin/activate \
 && python3 -m pip install --upgrade pip \
 && python3 -m pip install nvidia-tensorrt

CMD [ "/bin/bash" ]
