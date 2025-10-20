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

# Main execution
main() {
    echo "========================================="
    echo "ComfyUI Initialization"
    echo "========================================="
    
    # Setup ComfyUI-Manager
    setup_comfyui_manager
    
    echo "========================================="
    echo "Starting ComfyUI..."
    echo "========================================="
    
    # Start ComfyUI
    cd /comfyui
    exec python -u main.py --listen "$@"
}

# Run main function
main