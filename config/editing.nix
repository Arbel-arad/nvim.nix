{ nvimSize, pkgs, lib }:{

  options = {
    # Apparently these break treesitter's auto-indent functionality
    autoindent = false;
    smartindent = false;
  };

  globals = {
    editorconfig = true;
  };

  autocomplete = { # Which is better?
    nvim-cmp = {
      enable = true;
      sources = {
        buffer = "[Buffer]";
        nvim-cmp = null;
        path = "[path]";
        #async_path = "[async_path]"; # not showing highlight correctly
        #cmdline = "[cmd]"; # not showing in the cmdline
      };

      /*sourcePlugins = lib.mkForce [
        #pkgs.vimPlugins.cmp-cmdline
        "cmp-buffer"
        #pkgs.vimPlugins.cmp-async-path
      ];*/
      sourcePlugins = [
        pkgs.vimPlugins.cmp-async-path
      ];

      setupOpts = lib.mkIf false {
        sources = lib.mkForce [
          {
            name = "nvim_lsp";
          }
          {
            name = "luasnip";
          }
          {
            name = "buffer";
          }
          {
            name = "path";
            #name = "async_path";
          }
        ];
      };
    };

    blink-cmp = lib.mkIf false {
      enable = true;

      sourcePlugins = {
        ripgrep = {
          enable = true;
        };

        spell = {
          enable = true;
        };

        emoji = {
          enable = true;
        };
      };

      friendly-snippets = {
        enable = true;
      };

      setupOpts = {
        sources = {
          default = [
            "path"
            "buffer"
          ];

          providers = {
            lsp = {
              name = "LSP";
              module = "blink.cmp.sources.lsp";
              opts = {};

              enabled = true;
              async = true;
              timeout_ms = 2000;
              transform_items = null;
              should_show_items = true;
              max_items = null;
              min_keyword_length = 1;
              fallbacks = {};
              score_offset = 100;
              override = null;
            };
          };
        };

        cmdline = {
          keymap = {
            preset = "default";
          };
        };

        signature = {
          enabled = true;
        };

        completion = {
          menu = {
            border = "rounded";
            direction_priority = lib.generators.mkLuaInline /* Lua */ ''
              function()
                local ctx = require('blink.cmp').get_context()
                local item = require('blink.cmp').get_selected_item()
                if ctx == nil or item == nil then return { 's', 'n' } end

                local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                local is_multi_line = item_text:find('\n') ~= nil

                -- after showing the menu upwards, we want to maintain that direction
                -- until we re-open the menu, so store the context id in a global variable
                if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                  vim.g.blink_cmp_upwards_ctx_id = ctx.id
                  return { 'n', 's' }
                end
                return { 's', 'n' }
              end
            '';
          };

          ghost_text = {
            enable = true;
          };

          documentation = {
            auto_show = true;
            border = "rounded";
            auto_show_delay_ms = 500;
          };

          list = {
            selection = {
              preselect = true;
            };
          };
        };

        fuzzy = {
          implementation = "prefer_rust_with_warning";
        };
      };
    };
  };

  treesitter = {
    enable = true;

    addDefaultGrammars = true;

    context = {
      enable = false;
      setupOpts = {
        #multiwindow = true;
        mode = "topline";
        max_lines = 3;
        min_window_height = 50;
        separator = null;
        zindex = 10;
      };
    };

    autotagHtml = true;

    highlight = {
      enable = true;
    };

    indent = {
      enable = true;
    };

    textobjects = {
      enable = true;
    };
  };

  telescope = {
    enable = true;

    extensions = [
      {
        name = "fzf";
        packages = [
          pkgs.vimPlugins.telescope-fzf-native-nvim
        ];
        setup = {
          fzf = {
            fuzzy = true;
          };
        };
      }
      {
        name = "nerdy";
        packages = [
          pkgs.vimPlugins.nerdy-nvim
        ];
      }
    ];

    mappings = {

    };

    setupOpts = {
      defaults = {
        file_ignore_patterns = [
          "node_modules"
          "%.git/"
          "dist/"
          "build/"
          "target/"
          "result/"
          ".direnv/"
          ".zig-cache/"
          ".ccls-cache/"
          "%.lock"
        ];
      };
    };
  };

  autopairs = {
    nvim-autopairs = {
      enable = true;
    };
  };

  snippets = {
    luasnip = {
      enable = true;
    };
  };
}
