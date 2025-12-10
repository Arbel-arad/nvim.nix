{ nvimSize, self, inputs, pkgs, lib }: {
  enable = true;
  enableManpages = true;

  settings = let

    lib' = import ../flake/lib.nix { inherit lib; };

    inherit (inputs) nvf;

  in {
    vim = lib'.mergeAttrsList [
      (import ./misc.nix { inherit nvimSize pkgs lib; })
      (import ./utils.nix { inherit pkgs; })
      (import ./languages { inherit nvimSize inputs pkgs lib lib'; })
      (import ./lsp.nix { inherit nvimSize inputs pkgs lib; })
      (import ./debug.nix { inherit nvimSize pkgs lib; })
      (import ./formats.nix { inherit nvimSize; })
      (import ./editing.nix { inherit nvimSize pkgs; })
      (import ./embedded.nix { inherit nvimSize pkgs lib; })
      (import ./interface.nix { inherit nvimSize self pkgs lib; })
      (import ./keymaps.nix { inherit pkgs lib; })
      (import ./navigation.nix { inherit nvimSize; })
      (import ./diagnostics.nix { inherit nvimSize pkgs lib; })
      (import ./tests.nix { inherit pkgs lib; })
      (import ./remote.nix { inherit nvimSize pkgs lib; })
      (import ./spellcheck.nix { inherit nvf pkgs; })
      (import ./plugins {
        inherit nvimSize nvf pkgs lib lib';
      })


      {
        package = inputs.nvim-nightly.packages."${pkgs.stdenv.hostPlatform.system}".neovim;

        viAlias = true;
        vimAlias = true;

        options = {
          tabstop = 2;
          shiftwidth = 2; # should be equal to tabstop

          # Fold configuration for UFO-nvim and statuscol
          foldlevel = 99; # for folds and fillchars to show correctly
          foldcolumn = "auto:1"; # levels of folds to show
          fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";

          # For neorg
          conceallevel = 3;

          mousescroll = "ver:1,hor:1";
          mousemoveevent = true;
        };

        globals = {
          navic_silence = true; # navic tries to attach multiple LSPs and fails
          #suda_smart_edit = 1; # use super user write automatically
        } // (import ./neovide.nix { inherit pkgs; }).globals;

      }
    ];
  };
}
