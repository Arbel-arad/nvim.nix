{ nvimSize, npins, pkgs, lib }: let
  # Calculator

  enabled = nvimSize <= 500;

  qalc = npins."qalc.nvim";

in {
  extraPackages = lib.optionals enabled [
    pkgs.libqalculate
  ];

  lazy = {
    plugins = {
      "qalc.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "qalc.nvim";
          version = qalc.revision;

          src = qalc;
        };

        setupModule = "qalc";
        setupOpts = {

        };
      };
    };
  };
}
