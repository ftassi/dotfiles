# Check if inside a Distrobox and source cargo environment
if [ "$CONTAINER_ID" = "nvim" ]; then
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
fi
