#!/bin/bash
set -e

# Function to clean up stale git lock files
cleanup_git_locks() {
    local git_dir="$1"
    if [ -d "$git_dir" ]; then
        echo "  Cleaning up stale git lock files..."
        find "$git_dir" -name "*.lock" -type f -delete 2>/dev/null || true
    fi
}

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
            
            # Clean up any stale lock files
            cleanup_git_locks ".git"
            
            git reset --hard HEAD
            git pull origin main
            pip3 install -r requirements.txt
            echo "ComfyUI-Manager updated successfully!"
        else
            echo "ComfyUI-Manager found, skipping update (AUTO_UPDATE_MANAGER=false)"
        fi
    fi
}

# Function to setup/update ComfyUI-GGUF
setup_comfyui_gguf() {
    echo "=== Setting up ComfyUI-GGUF ==="
    
    if [ ! -d "/comfyui/custom_nodes/ComfyUI-GGUF" ]; then
        echo "ComfyUI-GGUF not found, installing..."
        git clone https://github.com/city96/ComfyUI-GGUF /comfyui/custom_nodes/ComfyUI-GGUF
        cd /comfyui/custom_nodes/ComfyUI-GGUF
        pip3 install --upgrade gguf
        echo "ComfyUI-GGUF installed successfully!"
    else
        if [ "${AUTO_UPDATE_GGUF:-true}" = "true" ]; then
            echo "ComfyUI-GGUF found, pulling latest changes..."
            cd /comfyui/custom_nodes/ComfyUI-GGUF
            
            # Clean up any stale lock files
            cleanup_git_locks ".git"
            
            git reset --hard HEAD
            git pull origin main
            pip3 install --upgrade gguf
            echo "ComfyUI-GGUF updated successfully!"
        else
            echo "ComfyUI-GGUF found, skipping update (AUTO_UPDATE_GGUF=false)"
        fi
    fi
}

# Function to setup/update ComfyUI-Impact-Pack
setup_comfyui_impact_pack() {
    echo "=== Setting up ComfyUI-Impact-Pack ==="
    
    if [ ! -d "/comfyui/custom_nodes/comfyui-impact-pack" ]; then
        echo "ComfyUI-Impact-Pack not found, installing..."
        git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git /comfyui/custom_nodes/comfyui-impact-pack
        cd /comfyui/custom_nodes/comfyui-impact-pack
        pip3 install -r requirements.txt
        echo "ComfyUI-Impact-Pack installed successfully!"
    else
        if [ "${AUTO_UPDATE_IMPACT_PACK:-true}" = "true" ]; then
            echo "ComfyUI-Impact-Pack found, pulling latest changes..."
            cd /comfyui/custom_nodes/comfyui-impact-pack
            
            # Clean up any stale lock files
            cleanup_git_locks ".git"
            
            git reset --hard HEAD
            git pull origin main
            pip3 install -r requirements.txt
            echo "ComfyUI-Impact-Pack updated successfully!"
        else
            echo "ComfyUI-Impact-Pack found, skipping update (AUTO_UPDATE_IMPACT_PACK=false)"
        fi
    fi
}
# Function to setup/update ComfyUI-Easy-Use
setup_comfyui_easy_use() {
    echo "=== Setting up ComfyUI-Easy-Use ==="
    
    if [ ! -d "/comfyui/custom_nodes/ComfyUI-Easy-Use" ]; then
        echo "ComfyUI-Easy-Use not found, installing..."
        git clone https://github.com/yolain/ComfyUI-Easy-Use.git /comfyui/custom_nodes/ComfyUI-Easy-Use
        cd /comfyui/custom_nodes/ComfyUI-Easy-Use
        pip3 install -r requirements.txt
        echo "ComfyUI-Easy-Use installed successfully!"
    else
        if [ "${AUTO_UPDATE_EASY_USE:-true}" = "true" ]; then
            echo "ComfyUI-Easy-Use found, pulling latest changes..."
            cd /comfyui/custom_nodes/ComfyUI-Easy-Use
            
            # Clean up any stale lock files
            cleanup_git_locks ".git"
            
            git reset --hard HEAD
            git pull origin main
            pip3 install -r requirements.txt
            echo "ComfyUI-Easy-Use updated successfully!"
        else
            echo "ComfyUI-Easy-Use found, skipping update (AUTO_UPDATE_EASY_USE=false)"
        fi
    fi
}

# Main execution
main() {
    echo "========================================="
    echo "ComfyUI Initialization"
    echo "========================================="
    
    # Setup ComfyUI-Manager
    setup_comfyui_manager
    
    # Setup ComfyUI-GGUF
    setup_comfyui_gguf

    # Setup ComfyUI-Impact-Pack
    setup_comfyui_impact_pack
    
    # Setup ComfyUI-Easy-Use
    setup_comfyui_easy_use
    
    echo "========================================="
    echo "Starting ComfyUI..."
    echo "========================================="
    
    # Start ComfyUI
    cd /comfyui
    exec python -u main.py --listen "$@"
}

# Run main function
main