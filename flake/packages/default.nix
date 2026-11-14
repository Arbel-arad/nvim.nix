{ inputs, self, self', nvf-pkgs, pkgs, pkgs-stable, lib }: let

  zellij = import (self + /tools/zellij/zellij.nix) {
    inherit self self' pkgs lib;
  };

  mkNvim = nvimConf: (
    inputs.nvf.outputs.lib.nvim.neovimConfiguration {
      pkgs = nvf-pkgs;
      modules = [
        (
          import (self + /config/neovim.nix) {
            inherit self nvimConf inputs pkgs pkgs-stable lib;
          }
        )
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

  oci = pkgs.callPackage ./oci.nix {
    inherit self';
  };

  #inherit ((import (self + /flake/packages/vm.nix) { inherit pkgs; })) vm-gui;
}
