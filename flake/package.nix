{ config, inputs, self, self', pkgs, lib }: let

  zellij = import (self + /tools/zellij/zellij.nix) {
    inherit self' pkgs lib;
  };

  mkNvim = nvimSize: (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
      inherit pkgs;
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

    postBuild = /* bash */ ''
      wrapProgram "$out/bin/nvim" \
        --prefix PATH : "${lib.makeBinPath self.nvim-config.extraPackages }"
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
