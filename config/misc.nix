{ self, npins, nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 300;

in {

  extraPackages = [
    (if nvimSize <= 500
      then pkgs.gitFull
      else pkgs.gitMinimal
    )
    pkgs.fzf
    # jq-LSP???
    pkgs.jq
    pkgs.nix

    (import (self + /config/tools/yazi.nix) {
      inherit pkgs;
    })

    (import (self + /config/tools/fish.nix) {
      inherit pkgs;
    })

    pkgs.nushell
    pkgs.direnv
    pkgs.openssh
    pkgs.hyperfine

    pkgs.lazysql
    pkgs.gitui
    pkgs.btop

    # For vim.lsp file watcher performance?
    pkgs.inotify-tools

  ] ++ lib.optionals enableExtra [
    # For opening weird office documents
    pkgs.unzip
    pkgs.pandoc

    # For sstrip
    pkgs.elfkickers

    # Binary analyzer
    pkgs.binsider

    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.imagemagick

    pkgs.attic-client

    pkgs.zellij

    # Networking
    pkgs.termshark
    pkgs.bandwhich

    # System utilities
    pkgs.uutils-coreutils-noprefix
    pkgs.uutils-findutils
  ];

  enableLuaLoader = true;

  withPython3 = enableExtra;
  withNodeJs = enableExtra;

  git = {
    enable = true;
    gitsigns = {
      enable = true;
      codeActions = {
        enable = false; # throws an annoying debug message
      };
    };
  };

  notify = {
    nvim-notify = {
      enable = true;
    };
  };

  projects = {
    # Replaced with neovim-project
    # https://github.com/coffebar/neovim-project
    #project-nvim.enable = true;
  };



  terminal = {
    toggleterm = {
      enable = true;
      lazygit.enable = true;
      mappings.open = null;
      setupOpts = {
        direction = "float";
        shell = "bash";
      };
    };
  };

  luaConfigRC = {

  };

  lazy = {
    plugins = {
      "trouble" = {
        enabled = true;

        package = lib.mkForce (pkgs.vimPlugins.trouble-nvim.overrideAttrs {
          pname = "trouble";

          src = npins."trouble.nvim";
        });

        lazy = true;
      };

      "vim-suda" = {
        package = pkgs.vimPlugins.vim-suda;
        setupOpts = {

        };
        lazy = true;
        event = ["BufEnter"];
      };

      "telescope-ui-select.nvim" = {
        package = pkgs.vimPlugins.telescope-ui-select-nvim;
        lazy = true;
      };

      "direnv.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "direnv.nvim";
          version = "0";

          src = npins."direnv.nvim";

          doCheck = true;
        };

        lazy = true;

        event = [
          "BufEnter"
        ];

        cmd = [
          "Direnv"
          "DirenvStatuslineRefresh"
        ];

        setupModule = "direnv";
        setupOpts = {
          autoload_direnv = true;
          statusline = {
            enabled = true;
            icon = " ";
          };

          keybindings = {
            allow = "<Leader>dea";
            deny = "<Leader>ded";
            reload = "<Leader>der";
            edit = "<Leader>dee";
          };
        };
      };

      "nerdy.nvim" = {
        package = pkgs.vimPlugins.nerdy-nvim;

        setupModule = "nerdy";

        setupOpts = {
          max_recents = 30;
          add_default_keybindings = false;
          copy_to_clipboard = false;
          copy_register = "+";
        };

        lazy = true;

        cmd = [
          "Nerdy"
        ];

        keys = [
          {
            mode = [
              "n"
            ];
            key = "<leader>in";
            action = "<cmd>Nerdy list<CR>";
            desc = "Browser nerd icons";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>iN";
            action = "<cmd>Nerdy recents<CR>";
            desc = "Browser recent nerd icons";
          }
        ];
      };
    };
  };
}
