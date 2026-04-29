{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 200;

  profile-rust = pkgs.writeShellScriptBin "profile-rust" /* bash */ ''
    cargo flamegraph --post-process 'flamelens --echo' $@
  '';

/*
  perf record --call-graph dwarf target/debug/*
  perf script --full-source-path -F +srcline | ./filter-perf.pl | stackcollapse-perf.pl out.perf > perf.log
*/

in {
  extraPackages = lib.optionals enabled [
    pkgs.perf
    pkgs.inferno
    pkgs.flamelens
    pkgs.cargo-criterion
    pkgs.gperftools
    pkgs.flamegraph

    profile-rust
  ];

  lazy = {
    plugins = {
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
