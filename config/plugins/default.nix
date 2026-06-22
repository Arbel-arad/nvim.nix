{ nvimSize, npins, nvf, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./yazi.nix { inherit pkgs; }) # TMP
  (if lib'.notAarch64 pkgs then (import ./orgmode.nix { inherit nvimSize npins nvf pkgs lib; }) else {})
  (import ./tree-sitter-comment.nix { inherit npins pkgs; })
  (import ./neovim-project.nix { inherit npins pkgs lib; })
  (import ./splits.nix { inherit npins pkgs lib; }).config
  (import ./sniprun.nix { inherit nvimSize pkgs lib; })
  (if lib'.notAarch64 pkgs then (import ./search-replace.nix { inherit npins nvimSize pkgs lib; }) else {})
  (import ./hex.nix { inherit pkgs lib; })
  (import ./just.nix { inherit npins pkgs; })
  (import ./exrc.nix { inherit npins pkgs; })
  (import ./kulala.nix { inherit nvimSize pkgs lib; })
  (import ./nvumi.nix { inherit nvimSize npins pkgs lib; })
  (import ./qalc.nix { inherit nvimSize npins pkgs lib; })
  #(import ./regexplainer.nix { inherit npins pkgs lib; })
]
