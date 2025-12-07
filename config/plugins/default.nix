{ nvimSize, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./yazi.nix { inherit pkgs; }) # TMP
  (import ./orgmode.nix { inherit pkgs lib; })
  (import ./neovim-project.nix { inherit pkgs lib; })
  (import ./splits.nix { inherit pkgs lib; }).config
  (import ./sniprun.nix { inherit nvimSize pkgs lib; })
]
