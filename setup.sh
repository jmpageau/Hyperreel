#!/bin/bash

# Install PyTorch
pip install torch
# Install NumPy
pip install numpy
# Install Hydra
pip install hydra-core
pip install omegaconf==2.1.1
pip install iopath==0.1.9
pip install pytorch_lightning==1.7.6
pip uninstall -y torchmetrics
pip install torchmetrics==0.11.4
pip install hydra-core==1.1.1
pip install imageio
pip install opencv-python
sudo apt install libgl1-mesa-glx -y
pip install scipy
pip install kornia
pip install matplotlib
pip install plyfile
pip install scikit-image
pip install pytorch3d
pip install lpips==0.1.4
pip install dearpygui
pip uninstall -y torch
pip install torch==1.12.1+cu113 torchvision==0.10.1+cu111 torchaudio==0.12.1 -f https://download.pytorch.org/whl/torch_stable.html
