{ config, inputs, self, self', pkgs, lib }: {
  default = self'.packages."nvim.nix";
  "nvim.nix" = (inputs.nvf.outputs.lib.nvim.neovimConfiguration {
    inherit pkgs;
    modules = [
      (import (self + /default.nix) {
        inherit config inputs pkgs lib;
      }).config.programs.nvf.settings
    ];
  }).neovim;

  #inherit ((import ../packages/vm.nix { inherit pkgs; })) vm-gui;
}
