#!/usr/bin/env bash
# test-ai-sandbox.sh — Verify that ai-sandbox.sh protects sensitive paths
#
# Usage: ./scripts/test-ai-sandbox.sh [project-dir]
#
# Runs a battery of tests inside the sandbox and reports PASS/FAIL.
# Exits 0 if all tests pass, 1 if any fails.
#
# IMPORTANT: run this script from OUTSIDE any sandbox session.
# Running from within a firejail session produces false negatives on
# should_allow tests: the outer sandbox may block paths that the inner
# sandbox correctly allows.

set -euo pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

SANDBOX="ai-sandbox.sh"
command -v "$SANDBOX" >/dev/null 2>&1 \
    || { echo "ERROR: $SANDBOX not found in PATH"; exit 1; }

[[ -d "$PROJECT_DIR" ]] \
    || { echo "ERROR: not a directory: $PROJECT_DIR"; exit 1; }

# ── Collect project-specific targets ──────────────────────────────────────

GIT_ROOT=""
if git -C "$PROJECT_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    GIT_ROOT="$(git -C "$PROJECT_DIR" rev-parse --show-toplevel)"
fi

# First gitignored DIRECTORY (if any) — excluding tool dirs that should stay
# accessible. We require a directory because firejail --blacklist only works
# reliably on directories under $HOME, not individual files.
GITIGNORED_SAMPLE=""
if [[ -n "$GIT_ROOT" ]]; then
    GITIGNORED_SAMPLE="$(
        git -C "$PROJECT_DIR" \
            ls-files --ignored --exclude-standard -o --directory \
            2>/dev/null \
        | grep '/$' \
        | grep -v '^\.\(claude\|codex\|aider\|continue\)/' \
        | head -1 \
        || true
    )"
    GITIGNORED_SAMPLE="${GITIGNORED_SAMPLE%/}"   # strip trailing /
    [[ -n "$GITIGNORED_SAMPLE" ]] \
        && GITIGNORED_SAMPLE="$GIT_ROOT/$GITIGNORED_SAMPLE"
fi

# First git-crypt encrypted path (if any)
GITCRYPT_SAMPLE=""
if [[ -n "$GIT_ROOT" ]] && command -v git-crypt >/dev/null 2>&1; then
    GITCRYPT_SAMPLE="$(
        git -C "$PROJECT_DIR" crypt status 2>/dev/null \
            | awk '/^ *encrypted: / { print $2; exit }'
    )"
    [[ -n "$GITCRYPT_SAMPLE" ]] \
        && GITCRYPT_SAMPLE="$GIT_ROOT/$GITCRYPT_SAMPLE"
fi

# First tracked (non-ignored) file — should stay accessible
TRACKED_SAMPLE=""
if [[ -n "$GIT_ROOT" ]]; then
    TRACKED_SAMPLE="$(
        git -C "$PROJECT_DIR" ls-files 2>/dev/null \
            | grep -v '^\.' | head -1
    )"
    [[ -n "$TRACKED_SAMPLE" ]] \
        && TRACKED_SAMPLE="$GIT_ROOT/$TRACKED_SAMPLE"
fi

# ── Tool allowlist fixture ─────────────────────────────────────────────────
# Creates a controlled git project to test GLOBAL_TOOL_ALLOWLIST:
#   - secret_cache/ : gitignored regular dir  → must be blocked
#   - .claude/      : gitignored tool dir     → must be accessible
# This is a self-contained test: it proves both that the dynamic blacklist
# works AND that GLOBAL_TOOL_ALLOWLIST rescues the right directories.
FIXTURE_DIR=""

setup_tool_fixture() {
    FIXTURE_DIR="$(mktemp -d)"
    trap 'rm -rf "$FIXTURE_DIR"' EXIT

    git -C "$FIXTURE_DIR" init -q
    git -C "$FIXTURE_DIR" config user.email "test@test.com"
    git -C "$FIXTURE_DIR" config user.name "Test"

    # Regular gitignored dir — must be blocked by dynamic blacklist
    echo "secret_cache/" >> "$FIXTURE_DIR/.gitignore"
    mkdir "$FIXTURE_DIR/secret_cache"
    echo "sensitive" > "$FIXTURE_DIR/secret_cache/data.txt"

    # .claude — gitignored but rescued by GLOBAL_TOOL_ALLOWLIST
    echo ".claude/" >> "$FIXTURE_DIR/.gitignore"
    mkdir "$FIXTURE_DIR/.claude"
    echo "# AGENT" > "$FIXTURE_DIR/.claude/AGENT.md"

    git -C "$FIXTURE_DIR" add .gitignore
    git -C "$FIXTURE_DIR" commit -q -m "init"
}

build_fixture_test_script() {
    local fixture_dir="$1"
    cat <<TESTEOF
pass=0; fail=0

should_block() {
    local label="\$1" path="\$2"
    if cat "\$path" >/dev/null 2>&1 || ls "\$path" >/dev/null 2>&1; then
        echo "FAIL  [EXPOSED]    \$label"
        (( fail++ )) || true
    else
        echo "PASS  [protected]  \$label"
        (( pass++ )) || true
    fi
}

should_allow() {
    local label="\$1" path="\$2"
    if cat "\$path" >/dev/null 2>&1 || ls "\$path" >/dev/null 2>&1; then
        echo "PASS  [accessible] \$label"
        (( pass++ )) || true
    else
        echo "FAIL  [BLOCKED]    \$label"
        (( fail++ )) || true
    fi
}

echo "=== Global tool allowlist (fixture) ==="
should_block "gitignored dir (not a tool dir)" "${fixture_dir}/secret_cache"
should_allow ".claude/ (gitignored, in GLOBAL_TOOL_ALLOWLIST)" "${fixture_dir}/.claude"

echo ""
echo "--- \$pass passed, \$fail failed ---"
exit \$fail
TESTEOF
}

# ── Build the inline test script ───────────────────────────────────────────

build_test_script() {
    cat <<TESTEOF
pass=0; fail=0

should_block() {
    local label="\$1" path="\$2"
    if [[ -z "\$path" ]]; then
        echo "SKIP  [no sample]  \$label"
        return
    fi
    if cat "\$path" >/dev/null 2>&1 || ls "\$path" >/dev/null 2>&1; then
        echo "FAIL  [EXPOSED]    \$label"
        (( fail++ )) || true
    else
        echo "PASS  [protected]  \$label"
        (( pass++ )) || true
    fi
}

# Known firejail limitation: --blacklist does not protect individual files
# inside \$HOME, only directories. Use this for cases where we want visibility
# into the gap without failing the test suite.
should_warn() {
    local label="\$1" path="\$2"
    if [[ -z "\$path" ]] || [[ ! -e "\$path" ]]; then
        echo "SKIP  [not found]  \$label"
        return
    fi
    if cat "\$path" >/dev/null 2>&1 || ls "\$path" >/dev/null 2>&1; then
        echo "WARN  [exposed]    \$label  (known firejail limitation for \$HOME files)"
    else
        echo "PASS  [protected]  \$label"
        (( pass++ )) || true
    fi
}

should_allow() {
    local label="\$1" path="\$2"
    if [[ -z "\$path" ]]; then
        echo "SKIP  [no sample]  \$label"
        return
    fi
    if cat "\$path" >/dev/null 2>&1 || ls "\$path" >/dev/null 2>&1; then
        echo "PASS  [accessible] \$label"
        (( pass++ )) || true
    else
        echo "FAIL  [BLOCKED]    \$label"
        (( fail++ )) || true
    fi
}

echo "=== Global blacklist ==="
should_block "~/.ssh/"              "\$HOME/.ssh"
should_block "~/.aws/"              "\$HOME/.aws"
should_block "~/.gnupg/"            "\$HOME/.gnupg"
should_block "~/.docker/"           "\$HOME/.docker"
should_block "~/.composer/"         "\$HOME/.composer"

echo ""
echo "=== Accessible (~/.config — not in blacklist) ==="
should_allow "~/.config/"           "\$HOME/.config"

echo ""
echo "=== Project dynamic ==="
should_block "gitignored sample"  "${GITIGNORED_SAMPLE}"
should_block "git-crypt sample"   "${GITCRYPT_SAMPLE}"

echo ""
echo "=== Accessible (tracked files) ==="
should_allow "tracked file sample" "${TRACKED_SAMPLE}"

echo ""
echo "--- \$pass passed, \$fail failed ---"
exit \$fail
TESTEOF
}

# ── Run ────────────────────────────────────────────────────────────────────

echo "Project : $PROJECT_DIR"
echo "Sandbox : $(command -v $SANDBOX)"
[[ -n "$GITIGNORED_SAMPLE" ]] && echo "Gitignored sample : $GITIGNORED_SAMPLE"
[[ -n "$GITCRYPT_SAMPLE"   ]] && echo "Git-crypt sample  : $GITCRYPT_SAMPLE"
[[ -n "$TRACKED_SAMPLE"    ]] && echo "Tracked sample    : $TRACKED_SAMPLE"
echo ""

total_fail=0

"$SANDBOX" "$PROJECT_DIR" bash -c "$(build_test_script)" 2>&1 \
    | grep -v "^Warning:\|remounting\|^Parent\|^Child\|initialized" \
    || (( total_fail++ )) || true

echo ""
echo "── Tool allowlist fixture ────────────────────────────────────────────────"
setup_tool_fixture
echo "Fixture   : $FIXTURE_DIR"
echo ""

"$SANDBOX" "$FIXTURE_DIR" bash -c "$(build_fixture_test_script "$FIXTURE_DIR")" 2>&1 \
    | grep -v "^Warning:\|remounting\|^Parent\|^Child\|initialized" \
    || (( total_fail++ )) || true

exit "$total_fail"
