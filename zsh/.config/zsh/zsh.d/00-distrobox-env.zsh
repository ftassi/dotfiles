# Se siamo dentro la distrobox "nvim", regola l'ambiente
if [ "$CONTAINER_ID" = "nvim" ]; then
    # Se esiste il file di configurazione di Cargo, esegui il sourcing
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    # Puoi aggiungere ulteriori configurazioni specifiche per la distrobox nvim
    # Ad esempio, aggiungi alla PATH la directory dei binari della distrobox:
    export PATH="$HOME/.local/distroboxes/nvim/bin:$PATH"
fi
