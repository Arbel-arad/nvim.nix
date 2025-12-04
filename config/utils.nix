{ pkgs }:{
  clipboard = {
    enable = true;
    providers = {
      wl-copy.enable = true;
    };
  };

  utility = {
    direnv = {
      #enable = true; # still uses old direnv.vim
    };

    yazi-nvim = {
      enable = true;
    };

    nix-develop.enable = true;

    outline.aerial-nvim = {
      enable = true;
    };

    preview = {
      markdownPreview = {
        enable = true;
        autoStart = false;
        autoClose = true;
        lazyRefresh = true;
      };
    };

    icon-picker.enable = true;

    diffview-nvim.enable = true;

    images = {
      image-nvim = {
        enable = true;
        setupOpts.backend = "kitty";
      };
    };

    surround = {
      enable = true;
    };

    ccc = {
      enable = true;
    };

    multicursors = {
      enable = true;
    };

    sleuth = {
      enable = true;
    };
  };

  notes = {
    todo-comments = {
      enable = true;
    };
    neorg = {
      enable = true;
      treesitter = {
        enable = true;
      };
      setupOpts = {
        load = {
          "core.defaults" = {
            enable = true;
          };
          "core.concealer" = {
            enable = true;
            config = {

            };
          };
          "core.completion" = {
            enable = true;
            config = {
              engine = "nvim-cmp";
            };
          };
        };
      };
    };
  };
}
