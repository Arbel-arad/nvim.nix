{ nvimSize, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./bars-lines.nix { inherit pkgs lib; })

  {
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

    minimap = {
      minimap-vim = {
        enable = false;
      };

      codewindow = {
        enable = true;
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
        #enable = true;
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

        setupOpts = {
          lsp = {
            progress = {
              enabled = false;
            };
          };
        };
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
        #enable = true;

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
          scope = {
            enabled = true;
          };

          exclude = {
            filetypes = [
              "dashboard"
              "alpha"
            ];
          };
        };
      };

      cinnamon-nvim = {
        #enable = true;

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

        nvim-ufo = {
          lazy = true;

          event = [
            {
              event = "User";
              pattern = "LazyFile";
            }
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
  }
]
