FROM nvcr.io/nvidia/tensorrt:24.06-py3
RUN echo 'root:root' | chpasswd
RUN useradd -ms /bin/bash docker
# pYTHON 3.10
 ENV DEBIAN_FRONTEND noninteractive
 RUN apt update && apt install -y tcl
 RUN apt install software-properties-common -y 
 RUN apt install vim -y 
 RUN add-apt-repository ppa:deadsnakes/ppa
 RUN apt install python3.10 -y &&  apt install python3-pip -y

 # SUDO
 RUN apt install sudo -y

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
# Upgrade PIP
RUN python -m pip install --upgrade pip
# PIP dependencies
RUN pip install --user -r /home/docker/requeriments.txt
# Build Jupyterlab

