{
  npins ? (import ./npins),
  nvimSize ? 0,
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {

  imports = [
    inputs.nvf.homeManagerModules.default
    ./home.nix
  ];

  config = {
    programs = {
      nvf = {
        enable = true;
        enableManpages = true;
        settings = import ./config/neovim.nix {
          inherit self inputs npins pkgs lib nvimSize;
        };
      };
    };
  };
}
