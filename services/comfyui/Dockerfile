FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    cmake \
    curl \
    git \
    iproute2 \
    libbz2-dev \
    libegl1 \
    libgl1 \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libglu1-mesa-dev \
    libglvnd-dev \
    libglx0 \
    libopencv-dev \
    libopengl0 \
    libx11-dev \
    libxcursor-dev \
    libxi-dev \
    libxinerama-dev \
    libxrandr-dev \
    mesa-common-dev \
    mesa-utils \
    ninja-build \
    pkg-config \
    python-is-python3 \
    python3 \
    python3-dev \
    python3-opencv \
    python3-pip \
    python3-psutil \
    rsync \
    software-properties-common \
    unzip \
    vim \
    wget \
    xauth \
    xvfb && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    libswscale-dev \
    python3-av && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Setup ComfyUI
WORKDIR /
RUN git clone https://github.com/comfyanonymous/ComfyUI.git comfyui && \
    pip3 install -r /comfyui/requirements.txt

# Setup ComfyUI Manager
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager && \
    pip3 install -r /comfyui/custom_nodes/ComfyUI-Manager/requirements.txt

# Setup ComfyUI GGUF
RUN git clone https://github.com/city96/ComfyUI-GGUF.git /comfyui/custom_nodes/ComfyUI-GGUF && \
    cd /comfyui/custom_nodes/ComfyUI-GGUF && \
    pip3 install --upgrade gguf

# Setup ComfyUI Impact Pack
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git /comfyui/custom_nodes/comfyui-impact-pack && \
    pip3 install -r /comfyui/custom_nodes/comfyui-impact-pack/requirements.txt

# Setup ComfyUI Easy Use
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use.git /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    pip3 install -r /comfyui/custom_nodes/ComfyUI-Easy-Use/requirements.txt

# Setup rgthree
RUN git clone https://github.com/rgthree/rgthree-comfy.git /comfyui/custom_nodes/rgthree-comfy && \
    pip3 install -r /comfyui/custom_nodes/rgthree-comfy/requirements.txt

# Setup QwenEditsUtil
RUN git clone https://github.com/lrzjason/Comfyui-QwenEditUtils.git /comfyui/custom_nodes/Comfyui-QwenEditUtils

# Setup SUPIR
RUN git clone https://github.com/kijai/ComfyUI-SUPIR.git /comfyui/custom_nodes/ComfyUI-SUPIR && \
    pip3 install -r /comfyui/custom_nodes/ComfyUI-SUPIR/requirements.txt

# Reinstall ComfyUI dependencies
RUN cd /comfyui && pip3 install -r requirements.txt

ENV ROOT=/comfyui

WORKDIR ${ROOT}
ENV NVIDIA_VISIBLE_DEVICES=all
EXPOSE 8188

# Add entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]