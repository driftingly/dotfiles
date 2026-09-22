#!/bin/bash
#
# Shared helpers for bin/install and bin/update. Sourced, never executed.

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

step()    { echo ""; echo -e "${BLUE}➜${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; exit 1; }

# brew bundle cannot drive installer-type casks, so LogiTune needs a hand.
check_installer_casks() {
    step "Checking installer-type casks"
    if [ ! -d "/Applications/Logi Tune.app" ] && [ ! -d "/Applications/LogiTune.app" ]; then
        local installer
        installer=$(find /opt/homebrew/Caskroom/logitune -name "LogiTuneInstaller.app" -maxdepth 2 2>/dev/null | head -1)
        if [ -n "$installer" ]; then
            warn "LogiTune needs manual installation, opening installer"
            open "$installer"
        fi
    fi
    success "Installer-type casks checked"
}

# fnm scopes global packages per Node version, so these are installed rather
# than updated. A package present under one version is absent under the next.
install_npm_globals() {
    step "Installing global npm packages"
    if ! command -v fnm &>/dev/null; then
        warn "fnm not found, skipping global npm packages"
        return 0
    fi
    eval "$(fnm env --use-on-cd)" || warn "fnm activation failed"
    fnm use lts-latest || warn "fnm use failed"
    npm install -g agent-browser defuddle || warn "Global npm install failed"
    agent-browser install 2>/dev/null || warn "agent-browser setup skipped"
    # agent-browser's skill is a thin stub that resolves its content from the
    # installed CLI at runtime, so it is pulled from upstream rather than
    # vendored. It lands in config/claude/skills, which .gitignore excludes.
    npx -y skills@latest add -g vercel-labs/agent-browser --copy -a claude-code -y \
        || warn "agent-browser skill install failed"
    success "npm packages processed"
}
