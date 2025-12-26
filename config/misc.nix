{ self, nvimSize, pkgs, lib }: let

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

    pkgs.fish
    pkgs.nushell
    pkgs.direnv
    pkgs.zellij
    pkgs.openssh
    pkgs.hyperfine

    pkgs.lazysql
    pkgs.gitui
    pkgs.btop

    # For vim.lsp file watcher performance?
    pkgs.inotify-tools

  ] ++ lib.optionals enableExtra [
    # For sstrip
    pkgs.elfkickers

    pkgs.ripgrep-all
    pkgs.imagemagick
    pkgs.attic-client

    # Networking
    pkgs.termshark
    pkgs.bandwhich
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
        package = lib.mkForce (pkgs.vimPlugins.trouble-nvim.overrideAttrs {
          pname = "trouble";
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "trouble.nvim";
            rev = "3fb3bd737be8866e5f3a170abc70b4da8b5dd45a";
            sha256 = "sha256-W6iO5f+q4busBuP0psE7sikn87wwc1BkztsMnVkjnW0=";
          };
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

      "rest.nvim" = {
        package = pkgs.vimPlugins.rest-nvim;
        setupOpts = {

        };

        lazy = true;

        ft = [
          "http"
        ];
      };

      "telescope-ui-select.nvim" = {
        package = pkgs.vimPlugins.telescope-ui-select-nvim;
        lazy = true;
      };

      "direnv.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "direnv.nvim";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "notashelf";
            repo = "direnv.nvim";
            rev = "4dfc8758a1deab45e37b7f3661e0fd3759d85788";
            hash = "sha256-KqO8uDbVy4sVVZ6mHikuO+SWCzWr97ZuFRC8npOPJIE=";
          };

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
            action = ":Nerdy list<CR>";
            desc = "Browser nerd icons";
          }
          {
            mode = [
              "n"
            ];
            key = "<leader>iN";
            action = ":Nerdy recents<CR>";
            desc = "Browser recent nerd icons";
          }
        ];
      };
    };
  };
}
