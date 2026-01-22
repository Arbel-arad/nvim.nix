{ config, inputs, self, self', nvf-pkgs, pkgs, lib }: let

  zellij = import (self + /tools/zellij/zellij.nix) {
    inherit self self' pkgs lib;
  };

  mkNvim = nvimSize: (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
      pkgs = nvf-pkgs;
      modules = [
        (
          import (self + /default.nix) {
            inherit nvimSize config inputs pkgs lib;
          }
        ).config.programs.nvf.settings
      ];
    }
  ).neovim;


in {

  default = self'.packages."nvim.nix";

  nvim = self'.packages."nvim.nix";

  "nvim.nix" = pkgs.symlinkJoin {
    name = "nvim.nix";

    paths = [
      (mkNvim 0)
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = let

      override-packages = [
        (import ../config/tools/fish.nix { inherit pkgs; })
        (import ../config/tools/yazi.nix { inherit pkgs; })
      ];

    in /* bash */ ''
      cp "$out/bin/nvim" "$out/bin/nvim-unwrapped"
      cp "$out/bin/nvim" "$out/bin/nvim-softwrapped"

      wrapProgram "$out/bin/nvim" \
        --set SHELL "fish" \
        --prefix PATH : "${lib.makeBinPath self.nvim-config.extraPackages}"

      wrapProgram "$out/bin/nvim-softwrapped" \
        --set SHELL "fish" \
        --prefix PATH : "${lib.makeBinPath override-packages}" \
        --suffix PATH : "${lib.makeBinPath self.nvim-config.extraPackages}"
    '';

    meta = {
      mainProgram = "nvim";
    };
  };

  nvim-gui = import (self + /packages/nvf-wrapped.nix) {
    inherit pkgs;
    nvf = self'.packages.default;
  };

  "nvim-minimal" = mkNvim 999;

  inherit (zellij) nvim-zellij;

  #inherit ((import ../packages/vm.nix { inherit pkgs; })) vm-gui;
}
