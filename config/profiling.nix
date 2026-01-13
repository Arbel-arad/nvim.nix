{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 200;

in {
  extraPackages = lib.optionals enabled [
    pkgs.perf
  ];

  lazy = {
    plugins = {
      "perfanno.nvim" = lib.mkIf enabled {
        package = pkgs.vimPlugins.perfanno-nvim;

        setupModule = "perfanno";
        setupOpts = {

        };
      };
    };
  };
}
