{ pkgs, lib }: {

  statusline = {
    lualine = {
      enable = true;

      theme = "iceberg_dark";

      activeSection = {
        c = [
          /* lua */ ''
            {
              "diff",
              colored = false,
              diff_color = {
                -- Same color values as the general color option can be used here.
                added    = 'DiffAdd',    -- Changes the diff's added color
                modified = 'DiffChange', -- Changes the diff's modified color
                removed  = 'DiffDelete', -- Changes the diff's removed color you
              },
              symbols = {added = '+', modified = '~', removed = '-'}, -- Changes the diff symbols
              separator = {right = ''}
            }
          ''

          /* lua */ ''
            function()
              return require('direnv').statusline()
            end
          ''

          /* lua */ ''
            function()
              local mode = require("submode").mode()
              if mode == nil then
                return '''
              else
                return mode
              end
            end
          ''

          /* lua */ ''
            function()
              return require("remote-sshfs.statusline").status()
            end
          ''
        ];
      };

      setupOpts = {
        options = {
          disabled_filetypes = rec {
            winbar = statusline;
            statusline = [
              # DAP-ui
              "dapui_breakpoints"
              "dapui_console"
              "dapui_watches"
              "dapui_scopes"
              "dapui_stacks"

              # DAP-view
              "dap-view-term"
              "dap-view"
              "dap-repl"

              # dashboards
              "snacks_dashboard"
              "dashboard"
              "startify"
              "alpha"
            ];
          };
        };
      };
    };
  };

  lazy = {
    plugins = {
      "dropbar.nvim" = {
        enabled = true;

        package = pkgs.vimPlugins.dropbar-nvim;
        setupModule = "dropbar";

        setupOpts = {
          bar = {
            hover = true;
          };
          menu = {
            preview = false;
          };
        };
      };
    };
  };

  extraPlugins = {
    "statuscol.nvim" = {
      package = pkgs.vimPlugins.statuscol-nvim;

      setup = /* lua */ ''
        local builtin = require("statuscol.builtin")
        --local ffi = require("statuscol.ffidef")
        --local C = ffi.C

        -- only show fold level up to this level
        --[[local fold_level_limit = 3
        local function foldfunc(args)
          local foldinfo = C.fold_info(args.wp, args.lnum)
          if foldinfo.level > fold_level_limit then
            return " "
          end

          return builtin.foldfunc(args)
        end]]
        local c = vim.cmd
        clickmod = "a"

        local function fold_click(args, open, other)
          -- Create fold on middle click
          --[[if args.button == "m" then
            create_fold(args)
            if other then return end
          end]]
          foldmarker = nil

          if args.button == "l" then -- Open/Close (recursive) fold on (clickmod)-click
            if open then
              c("norm! z"..(args.mods:find(clickmod) and "O" or "o"))
            else
              c("norm! z"..(args.mods:find(clickmod) and "C" or "c"))
            end
          --elseif args.button == "r" then -- Delete (recursive) fold on (clickmod)-right click
            --c("norm! z"..(args.mods:find(clickmod) and "D" or "d"))
          end
        end

        local npc = vim.F.npcall

        require("statuscol").setup {
          relculright = false,

          ft_ignore = {
            'snacks_dashboard',
            'dashboard',
          },
          bt_ignore = {
            'snacks_dashboard',
            'dashboard',
            'nofile',
          },

          segments = {
            { -- Git signs
              sign = {
                namespace = { "gitsigns" },
                maxwidth = 1,
                auto = " "
              },
              click = "v:lua.ScSa",
            },
            { -- Fold indicator
              text = {
                builtin.foldfunc,
                " ",
              },
              sign = {
                auto = "  ",
              },
              click = "v:lua.ScFa",
            },
            { -- Breakpoints / other
              sign = {
                name = { ".*" },
                maxwidth = 1,
                --auto = " ",
                auto = true,
                --wrap = true
              },
              click = "v:lua.ScSa",
            },
            { -- Diagnostics
              sign = {
                namespace = { "diagnostic" },
                maxwidth = 1,
                colwidth = 1,
                auto = " ",
                wrap = true
              },
              click = "v:lua.ScSa",
            },
            { -- Line numbers
              text = {
                builtin.lnumfunc, " "
              },
              click = "v:lua.ScLa",
            },
          },

          clickmod = "a",
          clickhandlers = {
            FoldClose = function(args)
              fold_click(args, true)
            end,
            FoldOpen = function(args)
              fold_click(args, false)
            end,
            FoldOther = function(args)
              --fold_click(args, false, true)
            end,
          }
        }
      '';
    };
  };
}
