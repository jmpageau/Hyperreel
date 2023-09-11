# Creates a basic PyTorch Docker Container

# Specify base
# Note! Make sure cuda version matches output from `nvcc --version`
# FROM nvidia/cuda:11.1.1-base-ubuntu18.04
#FROM ubuntu:18.04
FROM nvidia/cuda:11.5.2-cudnn8-runtime-ubuntu20.04

ARG USERNAME=developer
ARG USER_UID=15621
ARG USER_GID=110
ENV PATH="${PATH}:/home/${USERNAME}/.local/bin"

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Specify where you want your workspace
# Create workspace directory
RUN mkdir -p /home/$USERNAME/workspace/
RUN mkdir -p /root/data/immersive/
RUN wget -O /root/data/immersive/05_Horse.zip https://storage.googleapis.com/deepview_video_raw_data/05_Horse.zip
RUN unzip /root/data/immersive/05_Horse.zip -d /root/data/immersive/

# Set the working directory
WORKDIR /home/$USERNAME/workspace/
#ARG WORKDIR="/workspace"
#WORKDIR $WORKDIR

# Update the box (refresh apt-get)
RUN sudo apt-get update -y

# Linux Tools
RUN sudo apt-get install -y tmux htop
RUN sudo apt-get install -y wget curl iputils-ping
RUN sudo apt-get install -y zip unzip
RUN sudo apt-get install -y jq
RUN sudo apt-get install vim -y
# Update the box (refresh apt-get)
RUN sudo apt-get update -y

# Base Python
RUN sudo apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN sudo update-alternatives --install /usr/bin/python python $(which python3) 1
RUN pip3 install numpy tqdm
RUN pip3 install pyinstaller slack_sdk
RUN pip install pytorch-lightning

# Install Python 3.10 and non-Python dependencies
#RUN sudo apt-get install -y software-properties-common
#RUN sudo add-apt-repository ppa:deadsnakes/ppa
#RUN sudo apt-get install -y python3.10 python3.10-venv python3.10-dev python3.10-distutils binfmt-support python3-pip
RUN sudo apt-get update 
RUN pip3 install --upgrade pip


RUN sudo apt-get install -y python3 python3-pip
RUN sudo apt-get install -y git

# VS Code Server
# Note, not necessary, but significant time saver
#RUN wget "https://update.code.visualstudio.com/latest/server-linux-x64/stable" -O /tmp/vscode-server-linux-x64.tar.gz \  
#    && mkdir /tmp/vscode-server \  
#    && tar --no-same-owner -zxvf /tmp/vscode-server-linux-x64.tar.gz -C /tmp/vscode-server --strip-components=1 \  
#    && commit_id=$(cat /tmp/vscode-server/product.json | grep '"commit":' | sed -E 's/.*"([^"]+)".*/\1/') \  
#    && mkdir -p ~/.vscode-server/bin/${commit_id} \  
#    && cp -r /tmp/vscode-server/*  ~/.vscode-server/bin/${commit_id}/.  

# Update the box
#RUN sudo apt-get update -y

# Install Pillow
#RUN sudo apt-get install -y libjpeg8-dev zlib1g-dev 
#RUN pip3 install --upgrade pip Pillow

# Install pytorch
RUN pip3 install torch torchvision torchaudio

# Update the box (refresh apt-get)
RUN sudo apt-get update -y

# For tensorboard
#RUN pip3 install tensorboard tensorflow
# For tensorboard without tensorflow
#RUN pip3 install tensorboardX

# Update the box (refresh apt-get)
#RUN sudo apt-get update -y

# OpenCV
#RUN sudo apt-get install -y build-essential cmake git pkg-config libgtk-3-dev \
#    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
#    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
#    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
#    libtbb2 libtbb-dev libdc1394-22-dev
#RUN pip3 install opencv-python
#RUN pip3 install opencv-contrib-python

# Update the box (refresh apt-get)
RUN sudo apt-get update
RUN sudo apt-get install -y git
RUN sudo apt-get clean

#Get dependancies for HyperReel
RUN sudo apt-get update
RUN sudo apt-get install libgl1-mesa-glx
RUN sudo apt-get install libglib2.0-0

#Nvidia Supports
RUN sudo apt-get update
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
RUN sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
RUN sudo apt-get install software-properties-common
RUN sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
RUN sudo apt-get update
RUN sudo apt-get -y install cuda

# Install HyperReel
RUN cd /home/$USERNAME/workspace/
RUN sudo git clone --recursive https://github.com/facebookresearch/hyperreel.git
RUN sudo mkdir hyperreel/outputs
RUN sudo chmod 0777 hyperreel
#RUN mkdir -p hyperreel/root/data/immersive
#RUN wget -O hyperreel/root/data/immersive/05_Horse.zip https://storage.googleapis.com/deepview_video_raw_data/05_Horse.zip
#RUN unzip hyperreel/root/data/immersive/05_Horse.zip -d hyperreel/root/data/immersive/

# Update the box (refresh apt-get)
RUN sudo apt-get update -y

# Flask
#RUN pip3 install flask 

# OpenEXR
#RUN cd ~ 
#RUN git clone --recursive https://github.com/AcademySoftwareFoundation/openexr.git
#RUN cd openexr && git checkout release
#RUN mkdir -p openexr/build
#RUN apt-get install libghc-half-dev libopenexr-dev -y
#RUN cd openexr/build && cmake .. && make -j8 && make install
#RUN pip3 install openexr

# Skylibs (requires OpenEXR)
#RUN apt-get install -y libopenexr-dev
#RUN pip3 install openexr
#RUN pip3 install skylibs

# FFMPEG
#RUN sudo apt-get install -y ffmpeg

# Install pip requirements
COPY python_requirements.txt .
RUN sudo python -m pip install -r python_requirements.txt

# Cleanup 
RUN sudo apt-get clean autoclean
RUN sudo apt-get autoremove --yes
# Saves ~200MB but DESTROYS APT-GET!
# RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

# Creates a non-root user with an explicit UID
#ARG USER_NAME="toor"
#ARG USER_ID=5678
#ARG GROUP_ID=8765
#RUN groupadd -g ${GROUP_ID} docker 
#RUN useradd -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/bash ${USER_NAME}
#RUN echo "${USER_NAME}:toor" |  chpasswd 
#USER $USER_ID:${GROUP_ID}

# Copy VS Code Server to USER
# Note, not necessary, but significant time saver
#RUN commit_id=$(cat /tmp/vscode-server/product.json | grep '"commit":' | sed -E 's/.*"([^"]+)".*/\1/') \  
#    && mkdir -p ~/.vscode-server/bin/${commit_id} \  
#    && cp -r /tmp/vscode-server/*  ~/.vscode-server/bin/${commit_id}/.  