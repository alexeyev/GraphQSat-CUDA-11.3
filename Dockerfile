# Copyright 2019-2020 Nvidia Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04

ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64


RUN apt-get update -y && apt-get install -y software-properties-common curl sudo gcc unzip
#RUN add-apt-repository -y ppa:jblgf0/python
RUN apt-get update -y && \
    add-apt-repository -y multiverse && apt-get update -y && apt-get upgrade -y && \
    apt-get install -y apt-utils vim man build-essential wget sudo python3.7 python3.7-dev python3-pip wget  htop zlib1g-dev swig&& \
    rm -rf /var/lib/apt/lists/*

#RUN curl https://bootstrap.pypa.io/pip/3.7/get-pip.py | sudo python3.7

RUN update-alternatives --install /usr/local/bin/python python /usr/bin/python3.7 10
RUN python -m pip install --upgrade pip
RUN python -m pip install numpy scipy pyyaml matplotlib ruamel.yaml networkx tensorboardX
RUN python -m pip install pytorch==1.12.1 torchvision==0.13.1
RUN python -m pip install gym==0.17 setuptools

ENV CUDA_HOME /usr/local/cuda
ENV CPATH /usr/local/cuda/include
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/home/gqsat_user/gqsat/minisat/build/release/lib:$LD_LIBRARY_PATH
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX 7.5+PTX 8.0"

RUN python -m pip install --verbose --no-cache-dir torch_scatter==2.1.0
RUN python -m pip install --verbose --no-cache-dir torch-sparse==0.6.15
RUN python -m pip install --verbose --no-cache-dir torch-cluster==1.6.0
RUN python -m pip install torch-geometric

RUN python -m pip install tqdm

RUN useradd -ms /bin/bash gqsat_user
USER gqsat_user
WORKDIR /home/gqsat_user/gqsat

# to run the minisat binary
ENV PATH /home/gqsat_user/gqsat/minisat/build/release/bin:$PATH
