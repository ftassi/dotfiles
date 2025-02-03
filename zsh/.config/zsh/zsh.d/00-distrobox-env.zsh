# Se siamo dentro la distrobox "nvim", regola l'ambiente
if [ "$CONTAINER_ID" = "nvim" ]; then
    # Se esiste il file di configurazione di Cargo, esegui il sourcing
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    # Puoi aggiungere ulteriori configurazioni specifiche per la distrobox nvim
    # Ad esempio, aggiungi alla PATH la directory dei binari della distrobox:
    export PATH="$HOME/.local/distroboxes/nvim/bin:$PATH"

    # create a directory for nvm if not exists
    if [ ! -d "$HOME/opt/distroboxes/nvim/.nvm" ]; then
        mkdir -p "$HOME/opt/distroboxes/nvim/.nvm"
    fi

    export NVM_DIR="$HOME/opt/distroboxes/nvim/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
    fi
    # Puoi anche aggiungere il percorso dei binari di nvm (se necessario) al PATH
    export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"
fi
