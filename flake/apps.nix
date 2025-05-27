{ self' , pkgs }: {
  default = self'.apps."nvim.nix";
  "nvim.nix" = {
    type = "app";
    program = self'.packages.default;
  };
}
