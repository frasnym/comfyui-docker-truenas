#!/bin/bash
set -e

# Function to setup/update ComfyUI-Manager
setup_comfyui_manager() {
    echo "=== Setting up ComfyUI-Manager ==="
    
    if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager" ]; then
        echo "ComfyUI-Manager not found, installing..."
        git clone https://github.com/Comfy-Org/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
        cd /comfyui/custom_nodes/ComfyUI-Manager
        pip3 install -r requirements.txt
        echo "ComfyUI-Manager installed successfully!"
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
}

# Function to ensure model directories exist
setup_model_directories() {
    echo "=== Setting up model directories ==="
    
    local MODEL_DIRS=(
        "diffusion_models"
        "audio_encoders"
        "checkpoints"
        "clip"
        "clip_vision"
        "configs"
        "controlnet"
        "diffusers"
        "embeddings"
        "gligen"
        "hypernetworks"
        "loras"
        "model_patches"
        "photomaker"
        "style_models"
        "text_encoders"
        "unet"
        "upscale_models"
        "vae"
        "vae_approx"
    )
    
    local created_count=0
    
    for dir in "${MODEL_DIRS[@]}"; do
        if [ ! -d "/comfyui/models/$dir" ]; then
            echo "  Creating: /comfyui/models/$dir"
            mkdir -p "/comfyui/models/$dir"
            ((created_count++))
        fi
    done
    
    if [ $created_count -eq 0 ]; then
        echo "  All model directories already exist"
    else
        echo "  Created $created_count new model director(ies)"
    fi
}

# Main execution
main() {
    echo "========================================="
    echo "ComfyUI Initialization"
    echo "========================================="
    
    # Setup ComfyUI-Manager
    setup_comfyui_manager
    
    # Setup model directories
    setup_model_directories
    
    echo "========================================="
    echo "Starting ComfyUI..."
    echo "========================================="
    
    # Start ComfyUI
    cd /comfyui
    exec python -u main.py --listen "$@"
}

# Run main function
main