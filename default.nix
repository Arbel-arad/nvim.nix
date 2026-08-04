{
  npins ? (import ./npins),
  nvimConf ? { },
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {

  imports = [
    inputs.nvf.homeManagerModules.default
    ./flake/home.nix
  ];

  config = {
    programs = {
      nvf = {
        enable = true;
        enableManpages = true;
        settings = import ./config/neovim.nix {
          inherit self inputs npins pkgs lib nvimConf;
        };
      };
    };
  };
}
