# Check if inside a Distrobox and source cargo environment
if [ "$CONTAINER_ID" = "nvim" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi
