{ nvimSize, inputs, pkgs, lib }: {
  enable = true;
  enableManpages = true;

  settings = let

    mergeAttrsList =
    list:
    let
      # `binaryMerge start end` merges the elements at indices `index` of `list` such that `start <= index < end`
      # Type: Int -> Int -> Attrs
      binaryMerge =
        start: end:
        # assert start < end; # Invariant
        if end - start >= 2 then
          # If there's at least 2 elements, split the range in two, recurse on each part and merge the result
          # The invariant is satisfied because each half will have at least 1 element
          #binaryMerge start (start + (end - start) / 2) // binaryMerge (start + (end - start) / 2) end
          lib.recursiveUpdate (binaryMerge start (start + (end - start) / 2))  (binaryMerge (start + (end - start) / 2) end)
        else
          # Otherwise there will be exactly 1 element due to the invariant, in which case we just return it directly
          builtins.elemAt list start;
    in
    if list == [ ] then
      # Calling binaryMerge as below would not satisfy its invariant
      { }
    else
      binaryMerge 0 (builtins.length list);

    in {
    vim = mergeAttrsList [
      (import ./utils.nix { inherit pkgs; })
      (import ./lsp.nix { inherit nvimSize pkgs lib; })
      (import ./debug.nix { inherit nvimSize pkgs lib; })
      (import ./formats.nix { inherit nvimSize; })
      (import ./editing.nix { inherit nvimSize pkgs; })
      (import ./embedded.nix { inherit nvimSize pkgs; })
      (import ./interface.nix { inherit nvimSize pkgs lib; })
      (import ./keymaps.nix {})
      (import ./navigation.nix { inherit nvimSize; })
      (import ./diagnostics.nix { inherit nvimSize pkgs lib; })
      (import ./languages { inherit nvimSize pkgs lib; })
      (import ./plugins { inherit pkgs lib; })


      {
        package = inputs.nvim-nightly.packages."${pkgs.system}".neovim;

        viAlias = true;
        vimAlias = true;

        options = {
          tabstop = 2;
          shiftwidth = 2; # should be equal to tabstop

          foldlevel = 99; # for folds and fillchars to show correctly
          foldcolumn = "auto:1"; # levels of folds to show
          fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";

          # For neorg
          conceallevel = 3;

          mousescroll = "ver:1,hor:1";
          mousemoveevent = true;

          autoindent = true;
          smartindent = true;
        };

        globals = {
          navic_silence = true; # navic tries to attach multiple LSPs and fails
          #suda_smart_edit = 1; # use super user write automatically
        } // (import ./neovide.nix { inherit pkgs; }).globals;
      }
    ];
  };
}
