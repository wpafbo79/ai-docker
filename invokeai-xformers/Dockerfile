# syntax=docker/dockerfile:1

FROM wpafbo79/invokeai:v2.3.4.post1
ENV INVOKEAI_VERSION=v2.3.4.post1

SHELL ["/bin/bash", "--login", "-c"]

# Prevent packages from prompting for interactive inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Key directories
ENV BASE_DIR="/"
ENV INSTALL_DIR="${BASE_DIR}InvokeAI/"

# Install xFormers
WORKDIR ${INSTALL_DIR}
RUN source /.venv/bin/activate \
 && pip install \
    triton \
    xformers \
 && python -m xformers.info output

# Make existing data available to volumes. (Update)
ADD config.sh .
ADD Dockerfile .
