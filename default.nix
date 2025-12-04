{
  config,
  inputs,
  pkgs,
  lib,
  ...
}@self: let

  nvimSize = self.nvimSize or 0;

in {

  imports = [
    inputs.nvf.homeManagerModules.default
    ./home.nix
  ];

  config = {
    programs = {
      nvf = lib.recursiveUpdate {
        enableManpages = true;
        settings = {

        };
      } (import ./config/neovim.nix {
          inherit inputs pkgs lib nvimSize;
          self = ./.;
        });
    };
  };
}
