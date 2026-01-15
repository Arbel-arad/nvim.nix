{ nvf, npins, pkgs, lib }:{
  keymaps = [
    # Terminals
    {
      key = "<leader>tt";
      mode = [
        "n"
      ];
      silent = true;
      action = "<cmd>Lspsaga term_toggle fish<cr>";
      desc = "Lspsaga terminal";
    }
    {
      key = "<leader>ta";
      mode = [
        "n"
      ];
      silent = true;
      action = /* lua */ "<cmd>lua Snacks.terminal.open()<cr>";
      desc = "Open new terminal";
    }

    # Search
    # set hlsearch/nohlsearch for highlighting
    {
      #key = "<ESC><ESC>";
      key = "<leader>q";
      mode = [
        "n"
      ];
      silent = true;
      action = ":nohl<CR><C-l>";
      desc = "Clear search highlight";
    }

  ];

  binds = let

    inherit (nvf.lib.nvim.binds) pushDownDefault;

  in {
    whichKey = {
      enable = true;

      # Add whichkey groups for test and debug runners
      register = pushDownDefault {
        "<leader>r" = "+Run";
        "<leader>rt" = "+Run test";
        "<leader>rd" = "+Run debug";
        "<leader>rdw" = "+Debug mode";
        "<leader>rr" = "+Mount";
        "<leader>d" = "+Debug/Direnv";
        "<leader>de" = "+Direnv";
        "<leader>b" = "+Buffers";
      };
    };

    cheatsheet = {
      enable = true;
    };
  };


  lazy = {
    plugins = {
      "hydra.nvim" = {
        enabled = false;

        package = pkgs.vimPlugins.hydra-nvim;

        setupModule = "hydra";
        setupOpts = {

        };

        after = /* lua */ ''
          local Hydra = require("hydra")


          Hydra({
            name = "debugger",
            mode = "n",
            body = "<leader>rdw",
            config = {
              --foreign_keys = "run",
              hint = false,
              exit = false,

            },

            heads = {
              {
                "c",
                function()
                    require("dap").continue()
                end,
                {
                    desc = "Continue from breakpoint",
                    exit = false,
                }
              },
            },
          })
        '';
      };

      "submode.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "submode.nvim";
          version = "0";

          src = npins."submode.nvim";
        };

        after = /* lua */ ''
          local submode = require("submode")

          submode.create("Debugger", {
            mode = "n",
            enter = "<Space>rdw",
            leave = { "q", "<ESC>" },
            default = function(register)
              register("p",
                function()
                  vim.notify("test")
                end
              )
              register("c",
                function()
                  require("dap").continue()
                end
              )
              register("B",
                function()
                  require("dap").toggle_breakpoint()
                end
              )
            end,
          })

          submode.create("Tabs", {
            mode = "n",
            enter = "<Space>b",
            leave = { "n", "b", "q", "p", "r", "w", "<ESC>" },
            default = function(register)
              register("l",
                function()
                  vim.cmd("BufferNext")
                end
              )
              register("h",
                function()
                  vim.cmd("BufferPrevious")
                end
              )
              register("L",
                function()
                  vim.cmd("BufferMoveNext")
                end
              )
              register("H",
                function()
                  vim.cmd("BufferMovePrevious")
                end
              )
              register("k",
                function()
                  vim.cmd("tabnext")
                end
              )
              register("j",
                function()
                  vim.cmd("tabprevious")
                end
              )
            end,
          })
        '';
      };
    };
  };
}
