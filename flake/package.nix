{ config, inputs, self, self', pkgs, lib }: {

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

  #inherit ((import ../packages/vm.nix { inherit pkgs; })) vm-gui;
}
