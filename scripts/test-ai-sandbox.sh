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
#
# Test design: each assertion has two sides:
#   outside the sandbox: confirm the expected baseline (file exists/readable)
#   inside  the sandbox: confirm the sandbox changes access as expected
# This prevents false positives from files that were never accessible.

set -euo pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

SANDBOX="ai-sandbox"
command -v "$SANDBOX" >/dev/null 2>&1 \
    || { echo "ERROR: $SANDBOX not found in PATH"; exit 1; }

[[ -d "$PROJECT_DIR" ]] \
    || { echo "ERROR: not a directory: $PROJECT_DIR"; exit 1; }

# ── Helpers (outer shell — run outside sandbox) ────────────────────────────

outer_pass=0
outer_fail=0

# Verify a path IS accessible outside the sandbox.
# Returns 1 if not accessible (so callers can skip the sandbox test).
expect_accessible_outside() {
    local label="$1" path="$2"
    [[ -z "$path" ]] && return 1
    if cat "$path" >/dev/null 2>&1 || ls "$path" >/dev/null 2>&1; then
        echo "OUT   [accessible] $label"
        (( outer_pass++ )) || true
        return 0
    else
        echo "OUT   [UNREACHABLE] $label — skipping sandbox test (baseline failed)"
        (( outer_fail++ )) || true
        return 1
    fi
}

# ── Collect project-specific targets ──────────────────────────────────────

GIT_ROOT=""
if git -C "$PROJECT_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    GIT_ROOT="$(git -C "$PROJECT_DIR" rev-parse --show-toplevel)"
fi

# First gitignored path (file or dir) — excluding tool dirs that should stay
# accessible. Both files and directories are tested: firejail --blacklist
# works for both inside $HOME.
GITIGNORED_SAMPLE=""
if [[ -n "$GIT_ROOT" ]]; then
    GITIGNORED_SAMPLE="$(
        git -C "$PROJECT_DIR" \
            ls-files --ignored --exclude-standard -o --directory \
            2>/dev/null \
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
# Creates a controlled git project inside $HOME with known files:
#   - secret_cache/ : gitignored dir            → must be blocked
#   - .env          : gitignored file           → must be blocked
#   - .claude/      : gitignored tool dir       → must be accessible
#   - .envrc        : tracked file              → must be blocked (GLOBAL_PROJECT_BLACKLIST)
#   - subproject/   : monorepo subdirectory
#     - .envrc      : gitignored in subproject  → must be blocked
#     - .claude/    : gitignored in subproject  → must be accessible
#
# Baseline: all files are verified accessible BEFORE running the sandbox.
# This prevents false positives where a "protected" result is just a missing file.
FIXTURE_DIR=""

setup_tool_fixture() {
    FIXTURE_DIR="$(mktemp -d "$HOME/.sandbox-fixture-XXXXX")"
    trap 'rm -rf "$FIXTURE_DIR"' EXIT

    git -C "$FIXTURE_DIR" init -q
    git -C "$FIXTURE_DIR" config user.email "test@test.com"
    git -C "$FIXTURE_DIR" config user.name "Test"

    # Gitignored dir — must be blocked inside sandbox
    echo "secret_cache/" >> "$FIXTURE_DIR/.gitignore"
    mkdir "$FIXTURE_DIR/secret_cache"
    echo "sensitive" > "$FIXTURE_DIR/secret_cache/data.txt"

    # Gitignored individual file — must also be blocked (not just directories)
    echo ".env" >> "$FIXTURE_DIR/.gitignore"
    echo "SECRET=hunter2" > "$FIXTURE_DIR/.env"

    # .claude — gitignored but rescued by GLOBAL_TOOL_ALLOWLIST
    echo ".claude/" >> "$FIXTURE_DIR/.gitignore"
    mkdir "$FIXTURE_DIR/.claude"
    echo "# AGENT" > "$FIXTURE_DIR/.claude/AGENT.md"

    # .envrc — force-committed (simulates tracked file with secrets)
    echo "export SECRET=hunter2" > "$FIXTURE_DIR/.envrc"
    git -C "$FIXTURE_DIR" add .gitignore
    git -C "$FIXTURE_DIR" add -f .envrc
    git -C "$FIXTURE_DIR" commit -q -m "init"

    # subproject/ — monorepo subdirectory (sandbox launched from here)
    mkdir "$FIXTURE_DIR/subproject"
    echo ".envrc"  >> "$FIXTURE_DIR/subproject/.gitignore"
    echo ".claude/" >> "$FIXTURE_DIR/subproject/.gitignore"
    echo "export SUBPROJECT_SECRET=xyz" > "$FIXTURE_DIR/subproject/.envrc"
    mkdir "$FIXTURE_DIR/subproject/.claude"
    echo "# AGENT" > "$FIXTURE_DIR/subproject/.claude/AGENT.md"
    git -C "$FIXTURE_DIR" add subproject/.gitignore
    git -C "$FIXTURE_DIR" commit -q -m "add subproject"
}

build_fixture_test_script() {
    local fixture_dir="$1"
    cat <<TESTEOF
pass=0; fail=0

# Check content access: ls for directories, cat for files.
# Rationale: firejail --blacklist blocks content (ls for dirs, cat for files)
# but 'ls file' uses stat which remains accessible even for blacklisted files.
should_block() {
    local label="\$1" path="\$2"
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "FAIL  [EXPOSED]    \$label"
        (( fail++ )) || true
    else
        echo "PASS  [protected]  \$label"
        (( pass++ )) || true
    fi
}

should_allow() {
    local label="\$1" path="\$2"
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "PASS  [accessible] \$label"
        (( pass++ )) || true
    else
        echo "FAIL  [BLOCKED]    \$label"
        (( fail++ )) || true
    fi
}

echo "=== Dynamic blacklist (fixture) ==="
should_block "gitignored dir"            "${fixture_dir}/secret_cache"
should_block "gitignored file"           "${fixture_dir}/.env"

echo ""
echo "=== GLOBAL_TOOL_ALLOWLIST (fixture) ==="
should_allow ".claude/ (gitignored, rescued by allowlist)" "${fixture_dir}/.claude"

echo ""
echo "=== GLOBAL_PROJECT_BLACKLIST (fixture) ==="
should_block ".envrc (tracked, blocked by pattern)"  "${fixture_dir}/.envrc"

echo ""
echo ""
echo "--- \$pass passed, \$fail failed ---"
exit \$fail
TESTEOF
}

build_subdir_fixture_test_script() {
    local fixture_dir="$1"
    cat <<TESTEOF
pass=0; fail=0

should_block() {
    local label="\$1" path="\$2"
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "FAIL  [EXPOSED]    \$label"
        (( fail++ )) || true
    else
        echo "PASS  [protected]  \$label"
        (( pass++ )) || true
    fi
}

should_allow() {
    local label="\$1" path="\$2"
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "PASS  [accessible] \$label"
        (( pass++ )) || true
    else
        echo "FAIL  [BLOCKED]    \$label"
        (( fail++ )) || true
    fi
}

echo "=== Monorepo subdir (sandbox launched from subproject) ==="
should_block ".envrc in subdir (gitignored)"             "${fixture_dir}/subproject/.envrc"
should_allow ".claude/ in subdir (rescued by allowlist)" "${fixture_dir}/subproject/.claude"

echo ""
echo "--- \$pass passed, \$fail failed ---"
exit \$fail
TESTEOF
}

# ── Build the inline test script ───────────────────────────────────────────

build_test_script() {
    cat <<TESTEOF
pass=0; fail=0

# Check content access: ls for directories, cat for files.
# Rationale: firejail --blacklist blocks content (ls for dirs, cat for files)
# but 'ls file' uses stat which remains accessible even for blacklisted files.
should_block() {
    local label="\$1" path="\$2"
    if [[ -z "\$path" ]]; then
        echo "SKIP  [no sample]  \$label"
        return
    fi
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "FAIL  [EXPOSED]    \$label"
        (( fail++ )) || true
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
    local ok=false
    if [[ -d "\$path" ]]; then
        ls "\$path" >/dev/null 2>&1 && ok=true
    else
        cat "\$path" >/dev/null 2>&1 && ok=true
    fi
    if \$ok; then
        echo "PASS  [accessible] \$label"
        (( pass++ )) || true
    else
        echo "FAIL  [BLOCKED]    \$label"
        (( fail++ )) || true
    fi
}

echo "=== Credential dirs (not blocked — agent must impersonate user) ==="
should_allow "~/.ssh/"              "\$HOME/.ssh"
should_allow "~/.aws/"              "\$HOME/.aws"
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
echo ""

# ── Project test: baseline outside, then inside sandbox ───────────────────
echo "── Pre-flight (outside sandbox) ──────────────────────────────────────────"
[[ -n "$GITIGNORED_SAMPLE" ]] \
    && expect_accessible_outside "gitignored sample" "$GITIGNORED_SAMPLE" || true
[[ -n "$GITCRYPT_SAMPLE" ]] \
    && expect_accessible_outside "git-crypt sample"  "$GITCRYPT_SAMPLE"  || true
[[ -n "$TRACKED_SAMPLE" ]] \
    && expect_accessible_outside "tracked sample"    "$TRACKED_SAMPLE"   || true
echo ""

total_fail=0

echo "── Inside sandbox ────────────────────────────────────────────────────────"
"$SANDBOX" "$PROJECT_DIR" bash -c "$(build_test_script)" 2>&1 \
    | grep -v "^Warning:\|remounting\|^Parent\|^Child\|initialized" \
    || (( total_fail++ )) || true

# ── Fixture test: controlled environment, baseline + sandbox ───────────────
echo ""
echo "── Fixture pre-flight (outside sandbox) ──────────────────────────────────"
setup_tool_fixture
echo "Fixture : $FIXTURE_DIR"
echo ""
expect_accessible_outside "secret_cache/ (gitignored dir)"              "$FIXTURE_DIR/secret_cache"
expect_accessible_outside ".env (gitignored file)"                       "$FIXTURE_DIR/.env"
expect_accessible_outside ".claude/ (tool dir)"                          "$FIXTURE_DIR/.claude"
expect_accessible_outside ".envrc (tracked)"                             "$FIXTURE_DIR/.envrc"
expect_accessible_outside "subproject/.envrc (gitignored in subdir)"     "$FIXTURE_DIR/subproject/.envrc"
expect_accessible_outside "subproject/.claude/ (tool dir in subdir)"     "$FIXTURE_DIR/subproject/.claude"
echo ""

echo "── Fixture inside sandbox ────────────────────────────────────────────────"
"$SANDBOX" "$FIXTURE_DIR" bash -c "$(build_fixture_test_script "$FIXTURE_DIR")" 2>&1 \
    | grep -v "^Warning:\|remounting\|^Parent\|^Child\|initialized" \
    || (( total_fail++ )) || true

echo ""
echo "── Monorepo subdir fixture (sandbox launched from subproject) ────────────"
"$SANDBOX" "$FIXTURE_DIR/subproject" bash -c "$(build_subdir_fixture_test_script "$FIXTURE_DIR")" 2>&1 \
    | grep -v "^Warning:\|remounting\|^Parent\|^Child\|initialized" \
    || (( total_fail++ )) || true

echo ""
echo "── Summary ───────────────────────────────────────────────────────────────"
echo "Outside pre-flight: $outer_pass ok, $outer_fail failed"
[[ "$outer_fail" -gt 0 ]] && (( total_fail += outer_fail )) || true
exit "$total_fail"
