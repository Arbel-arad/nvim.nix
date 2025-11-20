set quiet

get-size:
  nix path-info $(nix eval .#packages.x86_64-linux.default --raw --quiet --option warn-dirty false 2>/dev/null) -h -S -s
explore-drv:
  nix-tree $(nix eval .#packages.x86_64-linux.default --raw --quiet --option warn-dirty false 2>/dev/null)
