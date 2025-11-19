#!/usr/bin/env bash

# --home          will open home.nix
# --config        will open configuration.nix
# --hostname=NAME will set the hostname name, otherwise it will run hostname
#                 by default, no file is opened

# Exist on any command error
set -e

HOME_FLAG=false
CONFIG_FLAG=false
HOSTNAME=$(hostname)

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
        --hostname=*)
            HOSTNAME="${1#*=}"
            shift
            ;;
        *)
            echo "\e[33mUnknown option: $1\e[0m"
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
    echo -e "\e[31mAborting rebuild...\e[0m"
    exit 0
fi

if $CONFIG_FLAG; then
    "$EDITOR" "$HOME/nixos-config/nixos/configuration.nix"
fi

# In case the editor failed
if [[ $? -ne 0 ]]; then
    echo -e "\e[31mAborting rebuild...\e[0m"
    exit 0
fi

pushd "$HOME/nixos-config"

# Detect if any changes were made wrt the last commit
if [[ -z $(git status --porcelain) ]]; then
    echo -e "\e[33mNo changes detected. Aborting rebuild.\e[0m"
    exit 0
fi

echo -e "\e[36m== Formatting ==\e[0m"

# Format
nix fmt **/*.nix

# Show git changes
git diff -U0 '*.nix'

echo "🔁 Rebuilding NixOS..."

# Rebuild
sudo nixos-rebuild switch --flake .#$HOSTNAME

# Get current generation metadata
hname="${HOSTNAME:0:1}"

current=$(nixos-rebuild list-generations | grep current | awk -v X="$hname" '
{
    split($3, d, "-")
    m["1"]="Jan"; m["2"]="Feb"; m["3"]="Mar"; m["4"]="Apr"
    m["5"]="May"; m["6"]="Jun"; m["7"]="Jul"; m["8"]="Aug"
    m["9"]="Sep"; m["10"]="Oct"; m["11"]="Nov"; m["12"]="Dec"

    printf "Gen #%s-%s on %s. %d, %d\n", $1, X, m[d[2]+0], d[3]+0, d[1]
}')

# Commit with metadata message
git commit -am "$current"

echo "✅ Rebuilt changes and commited $current"

popd
