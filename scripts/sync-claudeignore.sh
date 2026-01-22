#!/bin/bash
# Syncs .claudeignore with git-crypt patterns from .gitattributes
# Preserves manual entries between markers

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
GITATTRIBUTES="$REPO_ROOT/.gitattributes"
CLAUDEIGNORE="$REPO_ROOT/.claudeignore"

START_MARKER="# >>> AUTO-GENERATED (git-crypt) - DO NOT EDIT THIS SECTION <<<"
END_MARKER="# >>> END AUTO-GENERATED <<<"

# Extract git-crypt patterns
get_gitcrypt_patterns() {
    if [[ -f "$GITATTRIBUTES" ]]; then
        grep 'filter=git-crypt' "$GITATTRIBUTES" 2>/dev/null | awk '{print $1}' || true
    fi
}

# Extract manual section content (patterns and user comments only)
get_manual_section() {
    if [[ ! -f "$CLAUDEIGNORE" ]]; then
        return
    fi

    if grep -q "^$END_MARKER" "$CLAUDEIGNORE"; then
        # Get everything after END_MARKER, strip standard headers
        sed -n "/^$(echo "$END_MARKER" | sed 's/[[\.*^$()+?{|]/\\&/g')$/,\$p" "$CLAUDEIGNORE" \
            | tail -n +2 \
            | grep -v "^# Manual entries below" \
            | grep -v "^# Add patterns here for files" \
            | awk 'NF {found=1} found'
            # awk: skip leading blank lines, print from first non-empty line
    elif ! grep -q "^$START_MARKER" "$CLAUDEIGNORE"; then
        # No markers - migration case, skip old auto-generated headers
        grep -v "^# Auto-generated" "$CLAUDEIGNORE" \
            | grep -v "^# Do not edit manually" \
            | awk 'NF {found=1} found' \
            || true
    fi
}

# Build the new .claudeignore
build_claudeignore() {
    local patterns manual_section
    patterns=$(get_gitcrypt_patterns)
    manual_section=$(get_manual_section)

    {
        echo "$START_MARKER"
        echo "# Synced from .gitattributes - run scripts/sync-claudeignore.sh to update"
        if [[ -n "$patterns" ]]; then
            echo "$patterns"
        fi
        echo "$END_MARKER"
        echo ""
        echo "# Manual entries below - these are preserved across syncs"
        echo "# Add patterns here for files you want to protect BEFORE adding to git-crypt"
        echo ""
        if [[ -n "$manual_section" ]]; then
            echo "$manual_section"
        else
            # Default protective patterns for new installations
            cat << 'DEFAULTS'
# Common secret patterns (preventive protection)
**/*.secret
**/*.key
**/*.pem
**/.env
**/.env.*
**/credentials*
**/secrets*
DEFAULTS
        fi
    }
}

# Main
NEW_CONTENT=$(build_claudeignore)
echo "$NEW_CONTENT" > "$CLAUDEIGNORE"

echo ".claudeignore synced (manual entries preserved)"
