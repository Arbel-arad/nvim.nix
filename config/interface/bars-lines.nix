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
