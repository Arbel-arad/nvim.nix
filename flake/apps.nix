{ self, self' , pkgs }: {
  default = self'.apps."nvim.nix";
  "nvim.nix" = {
    type = "app";
    program = self'.packages.default;
    meta = {
      description = "Neovim";
    };
  };
  gui = (import (self + /packages/nvf-wrapped.nix) {
    inherit pkgs;
    nvf = self'.packages.default;
  }) // {
    meta = {
      description = "Neovide GUI";
    };
  };
}
