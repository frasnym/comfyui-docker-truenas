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
    cd comfyui && \
    git reset --hard v0.3.65 && \
    pip3 install -r requirements.txt

# Setup ComfyUI Manager
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager && \
    cd /comfyui/custom_nodes/ComfyUI-Manager && \
    git checkout main && \
    pip3 install -r requirements.txt

# Setup ComfyUI GGUF
RUN git clone https://github.com/city96/ComfyUI-GGUF.git /comfyui/custom_nodes/ComfyUI-GGUF && \
    cd /comfyui/custom_nodes/ComfyUI-GGUF && \
    pip3 install --upgrade gguf

ENV ROOT=/comfyui

WORKDIR ${ROOT}
ENV NVIDIA_VISIBLE_DEVICES=all
EXPOSE 8188

# Add entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]