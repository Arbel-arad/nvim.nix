{ config, inputs, self, self', pkgs, lib }: let

  zellij = import (self + /tools/zellij/zellij.nix) { inherit self' pkgs lib; };

in {

  default = self'.packages."nvim.nix";

  "nvim.nix" = (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
    inherit pkgs;
    modules = [
      (import (self + /default.nix) {
        inherit config inputs pkgs lib;
        nvimSize = 0;
      }).config.programs.nvf.settings
    ];
  }).neovim;

  nvim-gui = import (self + /packages/nvf-wrapped.nix) {
    inherit pkgs;
    nvf = self'.packages.default;
  };

  "nvim-minimal" = (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
    inherit pkgs;
    modules = [
      (import (self + /default.nix) {
        inherit config inputs pkgs lib;
        nvimSize = 999;
      }).config.programs.nvf.settings
    ];
  }).neovim;

  inherit (zellij) nvim-zellij;

  #inherit ((import ../packages/vm.nix { inherit pkgs; })) vm-gui;
}
