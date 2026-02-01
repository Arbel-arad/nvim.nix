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

        keys = [
          {
            mode = [
              "n"
            ];
            key = "<leader>rtr";
            action = /* lua */ ''
              function()
                require('neotest').run.run({ suite = true })
              end
            '';
            lua = true;
            desc = "Run all tests";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>rts";
            action = /* lua */''
              function()
                require('neotest').summary.toggle()
              end
            '';
            lua = true;
            desc = "Toggle summary";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>rto";
            action = /* lua */''
              function()
                require('neotest').output.open()
              end
            '';
            lua = true;
            desc = "Show test output";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>rta";
            action = /* lua */''
              function()
                require('neotest').run.attach()
              end
            '';
            lua = true;
            desc = "Attach to nearest test";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>rtn";
            action = /* lua */''
              function()
                require('neotest').run.run()
              end
            '';
            lua = true;
            desc = "Run nearest test";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>rtd";
            action = /* lua */''
              function()
                require('neotest').run.run({strategy = 'dap'})
              end
            '';
            lua = true;
            desc = "Debug nearest test";
          }
        ];
      };

      neotest-zig = {
        package = pkgs.vimPlugins.neotest-zig;
      };

      neotest-bash = {
        package = pkgs.vimPlugins.neotest-bash;
      };

      /*nvim-nio = {
        package = pkgs.vimPlugins.nvim-nio;
      };*/
    };
  };

  startPlugins = with pkgs.vimPlugins; [
    nvim-nio
  ];
}
