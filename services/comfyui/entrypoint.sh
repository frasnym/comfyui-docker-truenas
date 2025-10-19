# entrypoint.sh
#!/bin/bash
set -e

# Check if ComfyUI-Manager exists in the mounted volume
if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager" ]; then
    echo "ComfyUI-Manager not found, installing..."
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
    cd /comfyui/custom_nodes/ComfyUI-Manager
    pip3 install -r requirements.txt
fi

# Start ComfyUI
exec python -u main.py --listen "$@"