{ nvimSize, pkgs }:{

  globals = {
    editorconfig = true;
  };

  autocomplete = { # Which is better?
    nvim-cmp = {
      enable = true;
      sources = {
        buffer = "[Buffer]";
        nvim-cmp = null;
        path = "[Path]";
        #async_path = "[Path]"; # not showing highlight correctly
        #cmdline = "[cmd]"; # not showing in the cmdline
      };

      sourcePlugins = [
        pkgs.vimPlugins.cmp-cmdline
        #pkgs.vimPlugins.cmp-async-path
      ];

      # setupOpts = lib.generators.mkLuaInline /* lua */ ''
      /*  sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      '';*/
    };

    blink-cmp = {
      enable = false;
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
      disable = [
        #"nix"
      ];
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
