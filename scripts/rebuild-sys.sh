#!/usr/bin/env bash

# --home    will open home.nix
# --config  will open configuration.nix
#           by default, no file is opened

# Exist on any command error
set -e

HOME_FLAG=false
CONFIG_FLAG=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --home)
            HOME_FLAG=true
            shift
            ;;
        --config)
            CONFIG_FLAG=true
            shift
            ;;
        *)
            echo "❔ Unknown option: $1"
            exit 1
            ;;
    esac
done

# Open selected files
if $HOME_FLAG; then
    "$EDITOR" "$HOME/nixos-config/home-manager/home.nix"
fi

# In case the editor failed
if [[ $? -ne 0 ]]; then
    echo "⛔ Aborting rebuild."
    exit 0
fi

if $CONFIG_FLAG; then
    "$EDITOR" "$HOME/nixos-config/nixos/configuration.nix"
fi

# In case the editor failed
if [[ $? -ne 0 ]]; then
    echo "⛔ Aborting rebuild."
    exit 0
fi

pushd "$HOME/nixos-config"

# Detect if any changes were made wrt the last commit
if [[ -z $(git status --porcelain) ]]; then
    echo "⏸️ No changes detected. Aborting rebuild."
fi

echo "🖌️  Formatting..."

# Format
nix fmt **/*.nix

# Show git changes
git diff -U0 '*.nix'

echo "🔁 Rebuilding NixOS..."

# Rebuild
sudo nixos-rebuild switch --flake .

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit with metadata message
git commit -am "$current"

echo "✅ Rebuilt changes and commited $current"

popd
