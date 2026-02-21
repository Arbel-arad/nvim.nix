{ pkgs, lib }: {

  statusline = {
    lualine = {
      enable = true;

      theme = "iceberg_dark";

      activeSection = {
        c = [
          # lua
          ''
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

          # lua
          ''
            function()
              return require('direnv').statusline()
            end
          ''

          # lua
          ''
            function()
              local mode = require("submode").mode()
              if mode == nil then
                return '''
              else
                return mode
              end
            end
          ''

          # lua
          ''
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

          refresh = {
            events = [
              "WinEnter"
              "BufEnter"
              "BufWritePost"
              "SessionLoadPost"
              "FileChangedShellPost"
              "VimResized"
              "Filetype"
              #"CursorMoved"
              #"CursorMovedI"
              "ModeChanged"
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

      "barbar.nvim" = {
        enabled = true;

        package = pkgs.vimPlugins.barbar-nvim.overrideAttrs (prev: {
          patches = prev.patches or [] ++ [
            ./barbar-click.patch
          ];
        });

        setupModule = "barbar";
        setupOpts = {
          animation = true;
          auto_hide = true;
          tabpages = true;
          clickable = true;
          focus_on_close = "previous";

          icons = {
            #button = "";
            button = false;

            diagnostics = lib.generators.mkLuaInline /* lua */ ''
              {
                [vim.diagnostic.severity.ERROR] = {enabled = true, icon = "󰅚 "},
                [vim.diagnostic.severity.WARN] = {enabled = true, icon = "󰀪 "},
                [vim.diagnostic.severity.INFO] = {enabled = true, icon = " "},
                [vim.diagnostic.severity.HINT] = {enabled = true, icon = " "},
              }
            '';

            gitsigns = lib.generators.mkLuaInline /* lua */ ''
              {
                added = {enabled = true, icon = '+'},
                changed = {enabled = true, icon = '~'},
                deleted = {enabled = true, icon = '-'},
              }
            '';

            filetype = {
              enabled = true;
              custom_colors = false;
            };

            #separator = {
            #  left = "▎";
            #  right = "";
            #};

            modified = {
              button = "●";
            };

            pinned = {
              button = "";
              filename = true;
            };

            preset = "slanted";

            #separator_at_end = true;
          };

          minimum_length = 10;
          maximum_length = 30;
        };

        lazy = true;

        event = [
          "BufEnter"
        ];

        keys = [
            {
              mode = [
                "n"
              ];
              key = "<leader>bn";
              action = "<Cmd>BufferNext<CR>";
              desc = "Buffer next";
            }
            {
              mode = [
                "n"
              ];
              key = "<leader>bb";
              action = "<Cmd>BufferPrevious<CR>";
              desc = "Buffer prev";
            }
            {
              mode = [
                "n"
              ];
              key = "<leader>bp";
              action = "<Cmd>BufferPin<CR>";
              desc = "Buffer pin";
            }
            {
              mode = [
                "n"
              ];
              key = "<leader>bw";
              action = "<Cmd>BufferClose<CR>";
              desc = "Buffer close";
            }
            {
              mode = [
                "n"
              ];
              key = "<leader>br";
              action = "<Cmd>BufferRestore<CR>";
              desc = "Buffer restore";
            }
            {
              mode = [
                "n"
              ];
              key = "<leader>bq";
              action = "<Cmd>BufferPick<CR>";
              desc = "Buffer pick";
            }
          ];
      };

      "scope.nvim" = {
        enabled = true;

        package = pkgs.vimPlugins.scope-nvim;

        setupModule = "scope";
        setupOpts = {
          pre_tab_leave = lib.generators.mkLuaInline /* lua */ ''
            function()
              vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabLeavePre'})
            end
          '';

          post_tab_enter = lib.generators.mkLuaInline /* lua */ ''
            function()
              vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabEnterPost'})
            end
          '';
        };

        lazy = true;
        event = [
          "BufEnter"
        ];

        after = /* lua */ ''
          vim.opt.sessionoptions:append("tabpages")
          --require("telescope").load_extension("scope")

          local scope_group = vim.api.nvim_create_augroup('scope', {})

          vim.api.nvim_create_autocmd({ 'User' }, {
            pattern = "SessionSavePre",
            group = scope_group,
            callback = function()
              vim.cmd([[ScopeSaveState]])
            end,
          })

          vim.api.nvim_create_autocmd({ 'User' }, {
            pattern = "SessionLoadPost",
            group = scope_group,
            callback = function()
              vim.cmd([[ScopeLoadState]])
            end,
          })
        '';
      };
    };
  };
}
