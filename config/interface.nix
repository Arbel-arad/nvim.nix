{ nvimSize, self, pkgs, lib }:{
  options = {
    foldlevel = 99; # for folds and fillchars to show correctly
    foldcolumn = "auto:1"; # levels of folds to show
    fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
  };

  theme = {
    enable = true;
    name = "catppuccin";
    style = "mocha";
    transparent = false;
  };

  filetree = {
    neo-tree = {
      enable = true;
      setupOpts = {
        enable_cursor_hijack = true;
      };
    };
  };

  tabline = {
    nvimBufferline = {
      enable = true;
      setupOpts = {
        options = {
          numbers = "none";
          truncate_names = true;
          tab_size = 18;
          style_preset = "minimal";
        };
      };
    };
  };

  dashboard = {
    dashboard-nvim = {
      #enable = true;

      setupOpts = {
        theme = "doom";

        config = {
          header = {};
          center = [
            {
              icon = " ";
              icon_hl = "Title";
              desc = "Find File           ";
              desc_hl = "String";
              key = "b";
              keymap = "SPC f f";
              key_hl = "Number";
              key_format = " %s"; # -- remove default surrounding `[]`
              action = "NeovimProjectHistory";
            }
         ];
          footer = {};
        };
      };
    };

    alpha = {
      #enable = true;

      theme = "theta";

      layout = [

      ];

      opts = {

      };
    };
  };

  utility = {
    snacks-nvim = {
      enable = true;

      setupOpts = {
        picker = {
          ui_select = false;
        };

        dashboard = {
          preset = {
            #pick = "telescope.nvim";
            keys = lib.generators.mkLuaInline /* lua */ ''
              {
                { icon = " ", key = "g", desc = "Find Text", action = "<leader>fg" },
                { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
                { icon = " ", key = "d", desc = "Find project", action = ":NeovimProjectHistory"},
                { icon = "󰺄 ", key = "a", desc = "All projects", action = ":NeovimProjectDiscover"},
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
                { icon = " ", key = "s", desc = "Restore Session", action = ":NeovimProjectLoadRecent"},
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                { icon = " ", key = "c", desc = "Config",
                  action = function()
                    local path = vim.fn.stdpath('config')
                    vim.cmd("cd " .. path)
                    vim.cmd("Telescope find_files")
                  end,
                  hidden = true,
                },
              },
            '';

            header = lib.generators.mkLuaInline ''[[

 N  E  O -- V  I  M

            ]]'';
          };

          sections = [
            {
              section = "terminal";
              cmd = "${import (self + /tools/colorprint) { inherit pkgs; }}/bin/colorprint";
              align = "center";
              indent = 23;
            }
            {
              section = "header";
            }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              icon = " ";
              title = "Projects";
              section = "projects";
              limit = 3;
              indent = 2;
              padding = 1;
            }
            {
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              limit = 3;
              indent = 2;
              padding = 1;
            }

            (lib.generators.mkLuaInline /* lua */ ''
              function()
                -- Disable folding on dashboard?
                vim.opt_local.foldenable = false

                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 1,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    align = "center",
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end,
            '')
          ];
        };
      };
    };
  };

  minimap = {
    minimap-vim = {
      enable = false;
    };

    codewindow = {
      enable = true;
    };
  };

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
            end,
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

  ui = {
    illuminate = {
      enable = true;
    };

    breadcrumbs = {
      enable = false;
      navbuddy = {
        enable = false;
      };
    };

    modes-nvim = {
      enable = true;
      setupOpts = {
        colors = {
          bg = "#303050";
          copy = "#f5c359";
          delete = "#c75c6a";
          change = "#c75c6a";
          format = "#c79585";
          replace = "#245361";
          visual = "#9745be";
          insert = "#75c6df";
        };
      };
    };
    fastaction = {
      enable = true;
    };
    borders = {
      enable = true;
      plugins = {
        fastaction.enable = true;
        lsp-signature.enable = true;
        nvim-cmp.enable = true;
      };
    };

    nvim-ufo = {
      enable = true;
      setupOpts = {
        fold_virt_text_handler = lib.generators.mkLuaInline /* lua */ ''
          function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' 󰁂 %d '):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
              local chunkText = chunk[1]
              local chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
              else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, {chunkText, hlGroup})
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                end
                break
              end
              curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, 'MoreMsg'})
            return newVirtText
         end
        '';
      };
    };

    noice = {
      enable = true; # should i use this?
    };
  };

  visuals = {
    fidget-nvim = {
      enable = true;
      setupOpts = {
        progress = {
          # Disable repeated hot-reload LSP notifications
          suppress_on_insert = true;
        };
      };
    };

    nvim-web-devicons = {
      enable = true;
    };

    rainbow-delimiters = {
      enable = true;
    };

    nvim-scrollbar = {
      enable = true;
      setupOpts = {
        show_in_active_only = true;
        hide_if_all_visible = true;

        handlers = {
          cursor = false;
          gitsigns = true;
        };
      };
    };

    indent-blankline = {
      enable = true;
      setupOpts = {
        exclude = {
          filetypes = [
            "dashboard"
            "alpha"
          ];
        };
      };
    };

    cinnamon-nvim = {
      enable = true;
      setupOpts = {
        options = {
          #mode = "cursor";
          mode = "window";

          count_only = false;
        };

        keymaps = {
          basic = false;
          extra = false;
        };
      };
    };
  };

  lazy = {
    plugins = {
      "nvim-scrollview" = {
        enabled = false;
        package = pkgs.vimPlugins.nvim-scrollview;
        setupOpts = {
          signs_on_startup = [ "all" ];
        };
        lazy = true;
        event = ["BufEnter"];
      };

      "dropbar.nvim" = {
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

      nvim-ufo = {
        lazy = true;
        event = [
          {
            event = "User";
            pattern = "LazyFile";
          }
        ];
      };

      "screenkey.nvim" = let

        screenkey = pkgs.vimUtils.buildVimPlugin {
          pname = "screenkey.nvim";
          version = "2.4.2";

          src = pkgs.fetchFromGitHub {
            owner = "NStefan002";
            repo = "screenkey.nvim";
            rev = "ffe868e737d16d07a9792c8e04568cf8a2644cb7";
            hash = "sha256-hVpIWF9M8Ef7Ku02hti1JS4e1vHwNk3gY9+1VZ6DB20=";
          };
        };

      in {
        enabled = nvimSize <= 0;
        package = screenkey;

        setupModule = "screenkey";
        setupOpts = {
          win_opts = {
            row = 5;
            col = lib.generators.mkLuaInline /* lua */ "vim.o.columns - 5";
            anchor = "NE";

            width = 40;
            height = 1;

            title = "Inputs";
            title_pos = "center";

            focusable = false;
            noautocmd = true;
          };

          show_leader = false;


        };

        lazy = true;

        cmd = [
          "Screenkey"
        ];
      };
    };
  };

  luaConfigRC = {
    enableMouse = /* lua */ ''
      vim.cmd.aunmenu{'PopUp.How-to\\ disable\\ mouse'}
      vim.cmd.aunmenu{'PopUp.-2-'}
    '';
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
            {
              text = { " ", builtin.foldfunc, " " },
              condition = { builtin.not_empty, true, builtin.not_empty },
              click = "v:lua.ScFa"
            },
            { -- not working
              sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
              click = "v:lua.ScSa"
            },
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
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
