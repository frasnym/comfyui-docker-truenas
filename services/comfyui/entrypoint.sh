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

# Function to ensure model directories exist by syncing with ComfyUI repo structure
setup_model_directories() {
    echo "=== Setting up model directories ==="
    
    # Create temp directory
    local temp_dir=$(mktemp -d)
    
    echo "  Cloning ComfyUI repository to temporary location..."
    
    # Clone the entire ComfyUI repository (shallow clone for speed)
    git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git "$temp_dir/ComfyUI"
    
    echo "  Repository cloned successfully"
    
    local copied_count=0
    local skipped_count=0
    
    # Loop through each subdirectory in the temp models folder
    for model_subdir in "$temp_dir/ComfyUI/models"/*; do
        if [ -d "$model_subdir" ]; then
            # Extract just the directory name
            local dir_name=$(basename "$model_subdir")
            
            # Check if directory exists in mounted volume
            if [ ! -d "/comfyui/models/$dir_name" ]; then
                echo "  Copying: $dir_name (with contents)"
                # Copy the entire directory with all contents
                cp -r "$model_subdir" "/comfyui/models/$dir_name"
                ((copied_count++))
            else
                ((skipped_count++))
            fi
        fi
    done
    
    echo "  Summary: Copied $copied_count new director(ies), skipped $skipped_count existing"
    
    # Cleanup temp directory
    echo "  Cleaning up temporary files..."
    rm -rf "$temp_dir"
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