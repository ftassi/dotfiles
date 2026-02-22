#!/usr/bin/env bash
# ai-sandbox.sh — Secure wrapper for AI coding tools
#
# Threat model: accidental exfiltration — agent reads a sensitive file
# and includes it in context without the user noticing.
#
# Protection layers:
#   1. Filesystem blacklist (global static + project dynamic)
#   2. Environment clearenv + explicit whitelist
#   3. Docker socket mediation via docker-socket-proxy (TODO)
#
# Strategies:
#   Linux  → firejail (--noprofile + --blacklist per path)
#   macOS  → docker run with selective volume mounts (stub, see TODO)
#
# Usage:
#   ai-sandbox.sh <project-dir> <command> [args...]
#   ai-sandbox.sh init [project-dir]      # generate .ai-sandbox config
#
# Examples:
#   ai-sandbox.sh ~/myproject claude
#   ai-sandbox.sh init ~/myproject
#   ai-sandbox.sh . codex --model gpt-4o
#
# Environment overrides:
#   AI_SANDBOX_IMAGE    Docker image for macOS strategy (default: ai-sandbox)

set -euo pipefail

# ── Global blacklist (static) ──────────────────────────────────────────────
# Always blocked regardless of project. Cannot be overridden by .ai-sandbox.
# NOTE: ~/.config is intentionally broad — it may break some tool configs.
#       If an AI tool fails to start, comment ~/.config and add targeted
#       entries instead (e.g. ~/.config/gcloud, ~/.config/github-copilot).
#       "Matures over time" — adjust as you learn what actually breaks.
GLOBAL_BLACKLIST=(
    "$HOME/.aws"
    "$HOME/.ssh"
    "$HOME/.gnupg"
    "$HOME/.docker"
    "$HOME/.composer"
    "$HOME/.config"
)

# ── Environment whitelist ──────────────────────────────────────────────────
# Only these variables survive into the sandboxed process.
# AWS_*, GITHUB_TOKEN, DATABASE_URL and similar are stripped by design.
ENV_WHITELIST=(
    PATH
    HOME
    LANG
    LC_ALL
    TERM
    TERM_PROGRAM
    COLORTERM
    USER
    LOGNAME
    SHELL
    XDG_RUNTIME_DIR
    TMPDIR
)

# ── Project config defaults ────────────────────────────────────────────────
# Overridden by .ai-sandbox in the project git root.
AI_SANDBOX_ALLOW_PATHS=()
AI_SANDBOX_BLOCK_PATHS=()
AI_SANDBOX_ALLOW_ENV=()
AI_SANDBOX_BLOCK_ENV=()

# ── Helpers ────────────────────────────────────────────────────────────────

die()  { echo "ai-sandbox: ERROR: $*" >&2; exit 1; }
log()  { echo "ai-sandbox: $*" >&2; }

detect_os() {
    case "$(uname -s)" in
        Linux)  echo linux ;;
        Darwin) echo macos ;;
        *)      die "Unsupported OS: $(uname -s)" ;;
    esac
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 \
        || die "Required command not found: '$1'. Install it and retry."
}

# ── Project config (.ai-sandbox) ──────────────────────────────────────────

# Loads .ai-sandbox from the git root of project_dir, if present.
# Sets AI_SANDBOX_{ALLOW,BLOCK}_{PATHS,ENV} globals.
load_project_config() {
    local project_dir="$1"

    git -C "$project_dir" rev-parse --git-dir >/dev/null 2>&1 || return 0

    local git_root config
    git_root="$(git -C "$project_dir" rev-parse --show-toplevel)"
    config="$git_root/.ai-sandbox"

    [[ -f "$config" ]] || return 0

    log "Loading project config: $config"
    # shellcheck source=/dev/null
    source "$config"
}

# Returns 0 if the absolute path matches any entry in AI_SANDBOX_ALLOW_PATHS.
# Patterns in ALLOW_PATHS are relative to git_root; glob syntax is supported.
# A directory pattern (e.g. target/) also allows everything beneath it.
is_path_allowed() {
    local path="$1" git_root="$2"
    local allow abs_allow

    [[ ${#AI_SANDBOX_ALLOW_PATHS[@]} -eq 0 ]] && return 1

    shopt -s globstar 2>/dev/null || true

    for allow in "${AI_SANDBOX_ALLOW_PATHS[@]}"; do
        [[ "$allow" == /* ]] \
            && abs_allow="${allow%/}" \
            || abs_allow="$git_root/${allow%/}"

        # Unquoted $abs_allow: bash performs glob expansion on the right side
        # of ==, so patterns like "target/**" or "*.log" work as expected.
        # shellcheck disable=SC2254
        [[ "$path" == $abs_allow || "$path" == "$abs_allow/"* ]] && return 0
    done

    return 1
}

# ── Project blacklist (dynamic) ────────────────────────────────────────────
# Combines two sources:
#   a) gitignored untracked files/dirs  (git ls-files --ignored)
#   b) git-crypt encrypted files        (git crypt status)
#
# Prints absolute paths, one per line.
build_project_blacklist() {
    local project_dir="$1"

    git -C "$project_dir" rev-parse --git-dir >/dev/null 2>&1 || return 0

    local git_root
    git_root="$(git -C "$project_dir" rev-parse --show-toplevel)"

    # a) gitignored files/directories
    while IFS= read -r rel; do
        [[ -n "$rel" ]] || continue
        echo "$git_root/${rel%/}"   # strip trailing / git adds for dirs
    done < <(
        git -C "$project_dir" \
            ls-files --ignored --exclude-standard -o --directory \
            2>/dev/null
    )

    # b) git-crypt encrypted files
    if command -v git-crypt >/dev/null 2>&1; then
        while IFS= read -r rel; do
            [[ -n "$rel" ]] || continue
            echo "$git_root/$rel"
        done < <(
            git -C "$project_dir" crypt status 2>/dev/null \
                | awk '/^ *encrypted: / { print $2 }'
        )
    fi
}

# ── Environment ────────────────────────────────────────────────────────────
# Prints "KEY=VALUE" lines applying whitelist + project overrides.
collect_clean_env() {
    local var

    # Global whitelist
    for var in "${ENV_WHITELIST[@]}"; do
        # Skip if explicitly blocked by project config
        local blocked=false
        local b
        for b in "${AI_SANDBOX_BLOCK_ENV[@]+"${AI_SANDBOX_BLOCK_ENV[@]}"}"; do
            [[ "$var" == "$b" ]] && { blocked=true; break; }
        done
        $blocked && continue

        [[ -n "${!var+x}" ]] && printf '%s=%s\n' "$var" "${!var}"
    done

    # Project-level additions
    for var in "${AI_SANDBOX_ALLOW_ENV[@]+"${AI_SANDBOX_ALLOW_ENV[@]}"}"; do
        [[ -n "${!var+x}" ]] && printf '%s=%s\n' "$var" "${!var}"
    done
}

# ── Docker socket proxy ────────────────────────────────────────────────────
# TODO: start tecnativa/docker-socket-proxy with only CONTAINERS + EXEC
#       exposed so the agent can run docker exec without accessing the full
#       socket. Skipped for now — implement when firejail layer is stable.

# ── Linux strategy: firejail ───────────────────────────────────────────────

run_firejail() {
    local project_dir="$1"; shift
    local -a cmd=("$@")

    require_cmd firejail

    local git_root=""
    git -C "$project_dir" rev-parse --git-dir >/dev/null 2>&1 \
        && git_root="$(git -C "$project_dir" rev-parse --show-toplevel)"

    # ── Build blacklist ──────────────────────────────────────────────────
    local -a blacklist_args=()
    local path

    # Global layer (never filtered by ALLOW_PATHS)
    for path in "${GLOBAL_BLACKLIST[@]}"; do
        blacklist_args+=("--blacklist=$path")
    done

    # Project dynamic layer (gitignored + git-crypt), filtered by ALLOW_PATHS
    local allowed_count=0 blocked_count=0
    while IFS= read -r path; do
        [[ -n "$path" ]] || continue
        if [[ -n "$git_root" ]] && is_path_allowed "$path" "$git_root"; then
            (( allowed_count++ )) || true
        else
            blacklist_args+=("--blacklist=$path")
            (( blocked_count++ )) || true
        fi
    done < <(build_project_blacklist "$project_dir")

    # Project explicit extra blocks
    local rel
    for rel in "${AI_SANDBOX_BLOCK_PATHS[@]+"${AI_SANDBOX_BLOCK_PATHS[@]}"}"; do
        [[ "$rel" == /* ]] && path="$rel" || path="$git_root/$rel"
        blacklist_args+=("--blacklist=$path")
    done

    log "Blacklist: ${#GLOBAL_BLACKLIST[@]} global" \
        "+ ${blocked_count} project (${allowed_count} allowed by config)"

    # ── Build clean environment ──────────────────────────────────────────
    local -a env_cmd=("env" "-i")
    while IFS= read -r pair; do
        [[ -n "$pair" ]] && env_cmd+=("$pair")
    done < <(collect_clean_env)

    log "Launching: ${cmd[*]}"

    # env -i clears the environment; firejail then applies filesystem sandbox.
    # --noprofile: start from scratch, no default seccomp/caps profiles.
    # Hardware flags: restrict unnecessary device access.
    "${env_cmd[@]}" \
        firejail \
            --noprofile \
            --no3d \
            --nodvd \
            --nosound \
            --noautopulse \
            "${blacklist_args[@]}" \
            -- \
            "${cmd[@]}"
}

# ── macOS strategy: docker run ─────────────────────────────────────────────
# TODO: requires a Docker image with the AI tool pre-installed.
#       Build workflow TBD. For now this is a documented stub.
#
# The image must have the AI tool binary. Mount only the project dir.
# Sensitive $HOME paths are never mounted → exfiltration requires the agent
# to exfiltrate through the network, not the filesystem.

run_docker() {
    local project_dir="$1"; shift
    local -a cmd=("$@")

    require_cmd docker

    local image="${AI_SANDBOX_IMAGE:-ai-sandbox}"

    local -a env_flags=()
    while IFS= read -r pair; do
        [[ -n "$pair" ]] && env_flags+=("-e" "$pair")
    done < <(collect_clean_env)

    log "Launching in docker image '$image'"

    docker run --rm -it \
        -v "$project_dir:$project_dir:rw" \
        -w "$project_dir" \
        "${env_flags[@]}" \
        "$image" \
        "${cmd[@]}"
}

# ── Init: generate .ai-sandbox template ───────────────────────────────────

cmd_init() {
    local project_dir="${1:-.}"
    project_dir="$(realpath "$project_dir")"

    [[ -d "$project_dir" ]] || die "Not a directory: $project_dir"

    local git_root
    git_root="$(git -C "$project_dir" rev-parse --show-toplevel 2>/dev/null)" \
        || die "Not inside a git repository: $project_dir"

    local config="$git_root/.ai-sandbox"

    if [[ -f "$config" ]]; then
        die ".ai-sandbox already exists: $config"
    fi

    cat > "$config" <<'EOF'
# .ai-sandbox — project-level sandbox configuration
# Generated by: ai-sandbox.sh init
#
# This file is sourced as bash. Arrays support glob patterns.
# Paths are relative to the project git root (or absolute).
# See: https://github.com/ftassi/dotfiles

# ── Paths to ALLOW even if gitignored or git-crypt encrypted ──────────────
# Build artifacts, generated files, vendored deps — things the agent needs
# to read/execute but that aren't secrets.
#
#AI_SANDBOX_ALLOW_PATHS=(
#    target/           # Rust build artifacts
#    dist/             # JS/TS build output
#    .next/            # Next.js build cache
#    node_modules/     # npm packages
#    vendor/           # PHP/Go vendored deps
#    "**/*.log"        # log files anywhere in the tree
#    ".cache/"         # generic cache dirs
#)

# ── Paths to BLOCK in addition to the global + gitignored blacklist ────────
# Use this for tracked files that contain secrets (that shouldn't be there,
# but are — e.g. legacy config committed in plain text).
#
#AI_SANDBOX_BLOCK_PATHS=(
#    config/database.yml
#    infrastructure/terraform.tfvars
#    "**/*.pem"
#)

# ── Extra env vars to pass through to the agent ───────────────────────────
# Extend the global whitelist for project-specific variables that are safe.
#
#AI_SANDBOX_ALLOW_ENV=(
#    NODE_ENV
#    RAILS_ENV
#    APP_ENV
#)

# ── Env vars to strip even if in the global whitelist ─────────────────────
#
#AI_SANDBOX_BLOCK_ENV=(
#    SOME_INTERNAL_VAR
#)
EOF

    log "Created: $config"
    echo "$config"
}

# ── Main ───────────────────────────────────────────────────────────────────

usage() {
    cat >&2 <<EOF
Usage:
  $(basename "$0") <project-dir> <command> [args...]
  $(basename "$0") init [project-dir]

Commands:
  init   Generate a commented .ai-sandbox config in the project git root.
         Defaults to current directory if project-dir is omitted.

Sandboxes an AI tool with filesystem blacklisting and a clean environment.
Project-level overrides are read from .ai-sandbox in the git root.

Examples:
  $(basename "$0") ~/myproject claude
  $(basename "$0") . codex --model gpt-4o
  $(basename "$0") init ~/myproject

Environment:
  AI_SANDBOX_IMAGE   Docker image to use on macOS (default: ai-sandbox)
EOF
    exit 1
}

main() {
    [[ $# -ge 1 ]] || usage

    # Subcommand: init
    if [[ "$1" == "init" ]]; then
        cmd_init "${2:-}"
        return
    fi

    [[ $# -ge 2 ]] || usage

    local project_dir
    project_dir="$(realpath "$1")"
    shift

    local -a cmd=("$@")

    [[ -d "$project_dir" ]] || die "Not a directory: $project_dir"

    load_project_config "$project_dir"

    local os
    os="$(detect_os)"

    case "$os" in
        linux) run_firejail "$project_dir" "${cmd[@]}" ;;
        macos) run_docker   "$project_dir" "${cmd[@]}" ;;
    esac
}

main "$@"
