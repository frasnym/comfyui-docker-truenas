#!/bin/bash
set -e

# Configuration
readonly COMFYUI_ROOT="/comfyui"
readonly CUSTOM_NODES_DIR="${COMFYUI_ROOT}/custom_nodes"

# Plugin configurations: name, repo, directory, branch, dependencies command
declare -A PLUGINS=(
    ["ComfyUI-Manager"]="https://github.com/Comfy-Org/ComfyUI-Manager.git|ComfyUI-Manager|main|pip3 install -r requirements.txt|AUTO_UPDATE_MANAGER"
    ["ComfyUI-GGUF"]="https://github.com/city96/ComfyUI-GGUF.git|ComfyUI-GGUF|main|pip3 install --upgrade gguf|AUTO_UPDATE_GGUF"
    ["ComfyUI-Impact-Pack"]="https://github.com/ltdrdata/ComfyUI-Impact-Pack.git|comfyui-impact-pack|Main|pip3 install -r requirements.txt|AUTO_UPDATE_IMPACT_PACK"
    ["ComfyUI-Impact-Subpack"]="https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git|comfyui-impact-subpack|main|pip3 install -r requirements.txt|AUTO_UPDATE_IMPACT_SUBPACK"
    ["ComfyUI-Easy-Use"]="https://github.com/yolain/ComfyUI-Easy-Use.git|ComfyUI-Easy-Use|main|pip3 install -r requirements.txt|AUTO_UPDATE_EASY_USE"
    ["rgthree-comfy"]="https://github.com/rgthree/rgthree-comfy.git|rgthree-comfy|main|pip3 install -r requirements.txt|AUTO_UPDATE_RGTHREE"
    ["QwenEditsUtil"]="https://github.com/lrzjason/Comfyui-QwenEditUtils.git|Comfyui-QwenEditUtils|master||AUTO_UPDATE_QWEN"
    ["ComfyUI-SUPIR"]="https://github.com/kijai/ComfyUI-SUPIR.git|ComfyUI-SUPIR|main|pip3 install -r requirements.txt|AUTO_UPDATE_SUPIR"
)

# Logging functions
log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[SUCCESS] $*"
}

log_section() {
    echo "========================================="
    echo "$*"
    echo "========================================="
}

# Clean up stale git lock files
cleanup_git_locks() {
    local git_dir="$1"
    if [ -d "$git_dir" ]; then
        log_info "Cleaning up stale git lock files..."
        find "$git_dir" -name "*.lock" -type f -delete 2>/dev/null || true
    fi
}

# Install dependencies for a plugin
install_dependencies() {
    local deps_cmd="$1"
    if [ -n "$deps_cmd" ]; then
        log_info "Installing dependencies..."
        eval "$deps_cmd"
    fi
}

# Update existing plugin
update_plugin() {
    local plugin_dir="$1"
    local branch="$2"
    local deps_cmd="$3"
    
    cd "$plugin_dir"
    cleanup_git_locks ".git"
    
    log_info "Pulling latest changes from branch: $branch"
    git reset --hard HEAD
    git pull origin "$branch"
    
    install_dependencies "$deps_cmd"
    log_success "Updated successfully!"
}

# Install new plugin
install_plugin() {
    local repo_url="$1"
    local plugin_dir="$2"
    local branch="$3"
    local deps_cmd="$4"
    
    log_info "Installing from $repo_url..."
    git clone "$repo_url" "$plugin_dir"
    cd "$plugin_dir"
    git checkout "$branch"
    
    install_dependencies "$deps_cmd"
    log_success "Installed successfully!"
}

# Setup or update a plugin
setup_plugin() {
    local name="$1"
    local repo_url="$2"
    local dir_name="$3"
    local branch="$4"
    local deps_cmd="$5"
    local env_var="$6"
    
    local plugin_dir="${CUSTOM_NODES_DIR}/${dir_name}"
    local auto_update="${!env_var:-true}"
    
    log_section "Setting up $name"
    
    if [ ! -d "$plugin_dir" ]; then
        install_plugin "$repo_url" "$plugin_dir" "$branch" "$deps_cmd"
    else
        if [ "$auto_update" = "true" ]; then
            log_info "$name found, updating..."
            update_plugin "$plugin_dir" "$branch" "$deps_cmd"
        else
            log_info "$name found, skipping update ($env_var=false)"
        fi
    fi
}

# Process all plugins
setup_all_plugins() {
    for plugin_name in "${!PLUGINS[@]}"; do
        IFS='|' read -r repo dir branch deps env_var <<< "${PLUGINS[$plugin_name]}"
        setup_plugin "$plugin_name" "$repo" "$dir" "$branch" "$deps" "$env_var"
    done
}

# Main execution
main() {
    log_section "ComfyUI Initialization"
    
    # Setup all plugins
    setup_all_plugins
    
    log_section "Starting ComfyUI..."
    
    # Start ComfyUI
    cd "$COMFYUI_ROOT"
    exec python -u main.py --listen "$@"
}

# Run main function
main "$@"