#!/usr/bin/env bash

set -e

HOSTNAME=$(hostname)
pushd "$HOME/nixos-config"

echo -e "\e[36m== Formatting ==\e[0m"

# Show jj changes
jj diff -- 'glob:"**/*.nix"'

echo "🔁 Rebuilding NixOS..."

# Rebuild
sudo nixos-rebuild switch --flake .#$HOSTNAME

# Get current generation metadata
hname="${HOSTNAME:0:1}"

current=$(nixos-rebuild list-generations | grep True | awk -v X="$hname" '
{
    split($2, d, "-")
    m["1"]="Jan"; m["2"]="Feb"; m["3"]="Mar"; m["4"]="Apr"
    m["5"]="May"; m["6"]="Jun"; m["7"]="Jul"; m["8"]="Aug"
    m["9"]="Sep"; m["10"]="Oct"; m["11"]="Nov"; m["12"]="Dec"

    printf "Gen #%s-%s on %s. %d, %d\n", $1, X, m[d[2]+0], d[3]+0, d[1]
}')

# Commit with metadata message
jj commit -m "$current"
jj bookmark move main -t @-

echo "✅ Rebuilt changes and commited $current"

popd
