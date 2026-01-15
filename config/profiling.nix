{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 200;

in {
  extraPackages = lib.optionals enabled [
    pkgs.perf
    pkgs.inferno
    pkgs.flamelens
  ];

  lazy = {
    plugins = {
      # TODO: Figure out how to make this work
      "perfanno.nvim" = lib.mkIf enabled {
        package = pkgs.vimPlugins.perfanno-nvim;

        setupModule = "perfanno";
        setupOpts = {

        };

        lazy = true;
        cmd = [
          "PerfLoadFlat"
          "PerfLoadCallGraph"
          "PerfLoadFlameGraph"

          "PerfLuaProfileStart"
          "PerfLuaProfileStop"

          "PerfAnnotate"
          "PerfToggleAnnotations"
          "PerfAnnotateSelection"
          "PerfAnnotateFunction"

          "PerfHottestLines"
          "PerfHottestSymbols"
          "PerfHottestCallersSelection"
          "PerfHottestCallersFunction"

          "PerfCacheSave"
          "PerfCacheLoad"
          "PerfCacheDelete"
        ];
      };
    };
  };
}
