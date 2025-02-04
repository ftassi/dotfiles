# Se siamo dentro la distrobox "nvim", regola l'ambiente
if [[ "$CONTAINER_ID" == "$CONTAINER_ID" ]]; then
    # Se esiste il file di configurazione di Cargo, esegui il sourcing
    export CARGO_HOME="$HOME/distroboxes/$CONTAINER_ID/cargo"
    export RUSTUP_HOME="$HOME/distroboxes/$CONTAINER_ID/rustup"

    if [[ -f "$CARGO_HOME/env" ]]; then
        source "$CARGO_HOME/env"
    fi

    # Imposta NVM_DIR e carica nvm
    export NVM_DIR="$HOME/distroboxes/$CONTAINER_ID/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
    fi

    # Aggiungi alla PATH la directory dei binari specifica per la distrobox
    export PATH="$HOME/.local/distroboxes/$CONTAINER_ID/bin:$PATH"

    # Se nvm è disponibile, aggiungi alla PATH i binari di Node.js installati tramite nvm
    if command -v nvm >/dev/null; then
        export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"
    fi

fi
