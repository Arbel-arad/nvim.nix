{ pkgs, lib }: {

  statusline = {
    lualine = {
      enable = true;

      theme = "iceberg_dark";

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

        # https://github.com/NotAShelf/nvf/blob/5e4f212f8720c17fdd06f5c57591f251aff67453/docs/manual/release-notes/rl-26.12.md?plain=1#L42
        sections = {
          lualine_c = map lib.generators.mkLuaInline [
            # lua
            ''
              {
                "diff",
                colored = false,
                diff_color = {
                  -- Same color values as the general color option can be used here.
                  added    = 'DiffAdd',
                  modified = 'DiffChange',
                  removed  = 'DiffDelete',
                },
                symbols = { -- Changes the diff symbols
                  added = '+',
                  modified = '~',
                  removed = '-'
                },
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
              {
                "overseer",
                label = "", -- Prefix for task counts
                colored = true, -- Color the task icons and counts
                --symbols = {
                --  [overseer.STATUS.FAILURE] = "F:",
                --  [overseer.STATUS.CANCELED] = "C:",
                --  [overseer.STATUS.SUCCESS] = "S:",
                --  [overseer.STATUS.RUNNING] = "R:",
                --},
                unique = false, -- Unique-ify non-running task count by name
                status = nil, -- List of task statuses to display
                filter = nil, -- Function to filter out tasks you don't wish to display
              }
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
