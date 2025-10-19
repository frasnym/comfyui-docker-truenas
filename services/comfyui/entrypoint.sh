#!/bin/bash
set -e

# Check if ComfyUI-Manager exists in the mounted volume
if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager" ]; then
    echo "ComfyUI-Manager not found, installing..."
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
    cd /comfyui/custom_nodes/ComfyUI-Manager
    pip3 install -r requirements.txt
else
    if [ "${AUTO_UPDATE_MANAGER:-true}" = "true" ]; then
        echo "ComfyUI-Manager found, pulling latest changes..."
        cd /comfyui/custom_nodes/ComfyUI-Manager
        git reset --hard HEAD
        git pull origin main
        pip3 install -r requirements.txt
        echo "ComfyUI-Manager updated successfully!"
    else
        echo "ComfyUI-Manager found, skipping update (AUTO_UPDATE_MANAGER=false)"
    fi
fi

# Start ComfyUI
cd /comfyui
exec python -u main.py --listen "$@"