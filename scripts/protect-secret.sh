#!/bin/bash
# Protect a file/pattern from Claude BEFORE creating it
# Usage: protect-secret.sh <pattern> [--git-crypt]
#
# This adds the pattern to .claudeignore immediately.
# With --git-crypt, also adds to .gitattributes for encryption.

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
CLAUDEIGNORE="$REPO_ROOT/.claudeignore"
GITATTRIBUTES="$REPO_ROOT/.gitattributes"

if [[ -z "$1" ]]; then
    echo "Usage: protect-secret.sh <pattern> [--git-crypt]"
    echo ""
    echo "Examples:"
    echo "  protect-secret.sh my-api-key.txt"
    echo "  protect-secret.sh 'config/*.secret' --git-crypt"
    exit 1
fi

PATTERN="$1"
ADD_GITCRYPT=false

if [[ "$2" == "--git-crypt" ]]; then
    ADD_GITCRYPT=true
fi

# Add to .claudeignore if not already present
if ! grep -qF "$PATTERN" "$CLAUDEIGNORE" 2>/dev/null; then
    echo "$PATTERN" >> "$CLAUDEIGNORE"
    echo "Added '$PATTERN' to .claudeignore"
else
    echo "'$PATTERN' already in .claudeignore"
fi

# Optionally add to .gitattributes for git-crypt
if [[ "$ADD_GITCRYPT" == true ]]; then
    if ! grep -qF "$PATTERN" "$GITATTRIBUTES" 2>/dev/null; then
        echo "$PATTERN filter=git-crypt diff=git-crypt" >> "$GITATTRIBUTES"
        echo "Added '$PATTERN' to .gitattributes (git-crypt)"
    else
        echo "'$PATTERN' already in .gitattributes"
    fi
fi
