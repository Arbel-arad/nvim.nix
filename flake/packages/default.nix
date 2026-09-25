{ config, inputs, self, self', nvf-pkgs, pkgs, lib }: let

  zellij = import (self + /tools/zellij/zellij.nix) {
    inherit self self' pkgs lib;
  };

  mkNvim = nvimConf: (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
      pkgs = nvf-pkgs;
      modules = [
        (
          import (self + /default.nix) {
            inherit self nvimConf config inputs pkgs lib;
          }
        ).config.programs.nvf.settings
      ];
    }
  ).neovim;

in {

  default = self'.packages."nvim.nix";

  nvim = self'.packages."nvim.nix";

  "nvim.nix" = pkgs.callPackage ./nvim.nix {
    inherit self mkNvim;
  };

  nvim-gui = pkgs.callPackage ./nvim-gui.nix {
    nvf = self'.packages.default;
    inherit self;
  };

  "nvim-minimal" = mkNvim {
    size = 999;
  } // {
    # Required for bundling
    pname = "nvim-minimal";
  };

  testing = mkNvim {
    size = 0;
    test = true;
  };

  sandbox = (pkgs.callPackage ./sandbox.nix {
    nvim = self'.packages.default;
    inherit inputs;
  }).config.script;

  inherit (zellij) nvim-zellij;

  #inherit ((import (self + /flake/packages/vm.nix) { inherit pkgs; })) vm-gui;
}
