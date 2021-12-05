# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
ARG BASE_CONTAINER=ucsdets/datahub-base-notebook:2021.2-stable
#ARG BASE_CONTAINER=ucsdets/scipy-ml-notebook:2021.3-stable

FROM $BASE_CONTAINER

LABEL maintainer="Miles Labrador <github.com/mileslabrador>"

# 2) change to root to install packages
USER root

RUN apt-get update && \
    apt-get -y install aria2 nmap traceroute

# 3) install packages using notebook user (jovyan/jovian name means "like Jupiter"
# or, in our case Jupyter and is a standard in jupyter notebook development)
#USER jovyan

# upgrade numpy, since datahub's pods had been outdated in the past
#pip install --upgrade numpy && \ 

# install git so we can clone our repository
#apt-get -y install git && \

# install poetry to manage our dependencies
RUN pip install poetry==1.1.11 && \

# install the version of our repository from when this dockerfile is created
git clone https://github.com/kailingding/torchTS.git && cd torchTS && git checkout 01581e2e88d8df3181637361082ca0768173c495 && \
ls && \

echo GOT INTO TORCHTS FOLDER && \
cd torchts && \
ls && \
poetry install && \
# install our modified development torchts package from the cloned repository
poetry run pip install /home/jovyan/torchTS && \
# install matplotlib into our virtual environment
poetry run pip install matplotlib && \
# Activate poetry virtual environment
source $(poetry env info --path)/bin/activate

# Copy our build files locally to be embedded in the docker image
COPY run.py run.py 
COPY test-script.sh test-script.sh

# download our python file

# Override command to disable running jupyter notebook at launch
CMD ["/bin/bash"]