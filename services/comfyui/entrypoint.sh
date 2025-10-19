#!/bin/bash
set -e

# Check if ComfyUI-Manager exists in the mounted volume
if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager" ]; then
    echo "ComfyUI-Manager not found, installing..."
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
    cd /comfyui/custom_nodes/ComfyUI-Manager
    pip3 install -r requirements.txt
else
    echo "ComfyUI-Manager found, pulling latest changes..."
    cd /comfyui/custom_nodes/ComfyUI-Manager
    
    # Stash any local changes to avoid conflicts
    git stash
    
    # Pull latest changes
    git pull origin main
    
    # Install/update requirements
    pip3 install -r requirements.txt
    
    echo "ComfyUI-Manager updated successfully!"
fi

# Start ComfyUI
cd /comfyui
exec python -u main.py --listen "$@"