{ self, self' , pkgs }: {
  default = self'.apps."nvim.nix";
  "nvim.nix" = {
    type = "app";
    program = self'.packages.default;
  };
  gui = import (self + /packages/nvf-wrapped.nix) { inherit pkgs; };
}
