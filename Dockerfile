FROM nvcr.io/nvidia/tensorrt:24.07-py3
RUN echo 'root:root' | chpasswd
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
# Python 3.10
 ENV DEBIAN_FRONTEND noninteractive
 RUN apt update && apt install -y tcl
 RUN apt install software-properties-common -y 
 RUN apt install vim -y 
 RUN add-apt-repository ppa:deadsnakes/ppa
 RUN apt install python3.10 -y &&  apt install python3-pip -y




 # SUDO
 RUN apt install sudo -y
 ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.8/lib64:/usr/local/cuda-12.5/lib64

 # requeriments file
 COPY requeriments.txt /home/docker/requeriments.txt

# Init user docker
USER docker

ENV PATH=/home/docker/.local/bin:$PATH

 # Install NVM
ENV NVM_DIR /home/docker/nvm
RUN mkdir /home/docker/nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install --lts
# Install CONDA
ENV CONDA_DIR /home/docker/conda
RUN curl --silent https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -o /home/docker/conda_installer.sh
RUN bash /home/docker/conda_installer.sh -b -p ${CONDA_DIR}
ENV PATH=/home/docker/conda/bin:$PATH
RUN conda update conda
RUN conda init

# Upgrade PIP
RUN python -m pip install -q --upgrade pip
# PIP dependencies
RUN pip install --user -q -r /home/docker/requeriments.txt
# Build Jupyterlab

