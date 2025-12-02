#!/usr/bin/env bash

set -x
set -euo pipefail

CACHE="buildnix"

DEFAULT_P=$(nix build .#packages.x86_64-linux.default --no-link --json --quiet 2>/dev/null | jq '.[].outputs.out' -r)
MINIMAL_P=$(nix build .#packages.x86_64-linux.nvim-minimal --no-link --json --quiet 2>/dev/null | jq '.[].outputs.out' -r)
GUI_P=$(nix build .#packages.x86_64-linux.nvim-gui --no-link --json --quiet 2>/dev/null | jq '.[].outputs.out' -r)

attic push "$CACHE" "$DEFAULT_P" || true
attic push "$CACHE" "$MINIMAL_P" || true
attic push "$CACHE" "$GUI_P" || true

printf "full size:%s\n" "$(nix path-info -h -S -s "$GUI_P" | cut -f 2,3)"
printf "minimal size:%s\n" "$(nix path-info -h -S -s "$MINIMAL_P" | cut -f 2,3)"
