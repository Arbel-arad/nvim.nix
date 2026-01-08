{ nvimSize, npins, nvf, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./yazi.nix { inherit pkgs; }) # TMP
  (import ./orgmode.nix { inherit nvimSize npins nvf pkgs lib; })
  (import ./neovim-project.nix { inherit npins pkgs lib; })
  (import ./splits.nix { inherit npins pkgs lib; }).config
  (import ./sniprun.nix { inherit nvimSize pkgs lib; })
  (import ./hex.nix { inherit pkgs lib; })
  (import ./just.nix { inherit npins pkgs; })
  #(import ./regexplainer.nix { inherit npins pkgs lib; })
]
