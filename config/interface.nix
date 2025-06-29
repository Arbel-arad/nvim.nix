{ nvimSize, pkgs, lib }:{
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

      };
    };
    alpha = {
      enable = true;
      theme = "theta";
      layout = [

      ];
      opts = {

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
    };
    noice = {
      enable = true; # should i use this?
    };
  };

  visuals = {
    fidget-nvim = {
      enable = true;
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
  };

  lazy = {
    plugins = {
      "nvim-scrollview" = lib.mkIf false {
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
    };
  };
}
