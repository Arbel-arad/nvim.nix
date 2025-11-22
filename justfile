set quiet

default:
  just --list

get-size:
  nix path-info $(nix eval .#packages.x86_64-linux.default --raw --quiet --option warn-dirty false 2>/dev/null) -h -S -s
explore-drv:
  nix-tree $(nix eval .#packages.x86_64-linux.default --raw --quiet --option warn-dirty false 2>/dev/null)
print-config:
  nix run .#print-config --quiet --option warn-dirty false | bat --language lua
