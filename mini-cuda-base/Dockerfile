# syntax=docker/dockerfile:1

FROM nvidia/cuda:12.0.0-base-ubuntu22.04
ENV CUDA_VERSION=12.0.0

################################################################################
# Reference miniconda dockerfile:
#   https://hub.docker.com/r/continuumio/miniconda3/dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV MINICONDA3_VERSION=4.5.12
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

################################################################################
# Reference Tini project page:
#   https://github.com/krallin/tini
ENV TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT [ "/tini", "--" ]
CMD [ "/bin/bash" ]
