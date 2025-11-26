{ pkgs, lib }: lib.mergeAttrsList [
  (import ./yazi.nix { inherit pkgs; }) # TMP
  (import ./orgmode.nix { inherit pkgs lib; })
  (import ./neovim-project.nix { inherit pkgs lib; })
]
