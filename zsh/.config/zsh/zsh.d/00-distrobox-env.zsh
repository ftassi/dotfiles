# Se siamo dentro la distrobox "nvim", regola l'ambiente
if [[ "$CONTAINER_ID" == "nvim" ]]; then
    # Se esiste il file di configurazione di Cargo, esegui il sourcing
    if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
    fi

    # Aggiungi alla PATH la directory dei binari specifica per la distrobox
    export PATH="$HOME/.local/distroboxes/nvim/bin:$PATH"

    # Crea la directory per nvm se non esiste
    if [[ ! -d "$HOME/opt/distroboxes/nvim/.nvm" ]]; then
        mkdir -p "$HOME/opt/distroboxes/nvim/.nvm"
    fi

    # Imposta NVM_DIR e carica nvm
    export NVM_DIR="$HOME/opt/distroboxes/nvim/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
    fi

    # Se nvm è disponibile, aggiungi alla PATH i binari di Node.js installati tramite nvm
    if command -v nvm >/dev/null; then
        export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"
    fi
fi
