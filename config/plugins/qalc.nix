{ npins, pkgs }: let
  # Calculator

  qalc = npins."qalc.nvim";

in {
  extraPackages = [
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
