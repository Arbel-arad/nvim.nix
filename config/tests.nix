{ pkgs, lib }: {

  # Neotest seems to be broken currently
  # (at least in some languages)
  # https://github.com/nvim-neotest/neotest/issues/502

  lazy = {
    plugins = {
      neotest = {
        package = pkgs.vimPlugins.neotest.overrideAttrs (_: prev: {
          /*propagatedBuildInputs = prev.propagatedBuildInputs ++ [
            pkgs.vimPlugins.neotest-zig
            pkgs.vimPlugins.neotest-bash
          ];*/
        });

        setupModule = "neotest";
        setupOpts = {
          adapters = lib.generators.mkLuaInline /* lua */ ''
            {
              require("neotest-zig")({
                dap = {
                  adapter = "lldb",
                }
              }),

              require("neotest-bash")({
                executable = "${lib.getExe pkgs.bashunit}",
              }),

              require('rustaceanvim.neotest'),
            },
          '';
        };

        lazy = true;

        cmd = [
          "Neotest"
        ];
      };

      neotest-zig = {
        package = pkgs.vimPlugins.neotest-zig;
      };

      neotest-bash = {
        package = pkgs.vimPlugins.neotest-bash;
      };

      nvim-nio = {
        package = pkgs.vimPlugins.nvim-nio;
      };
    };
  };
}
