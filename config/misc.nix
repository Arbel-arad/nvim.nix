{ pkgs, lib }: {

  extraPackages = [
    pkgs.imagemagick
    pkgs.git
    pkgs.fzf
    pkgs.nix
    pkgs.cppcheck
    pkgs.yazi
    pkgs.fish
    pkgs.nushell
    pkgs.direnv
    pkgs.gitui
    pkgs.btop
    pkgs.zellij
    pkgs.openssh
    pkgs.ripgrep-all

    # For rust
    pkgs.cargo
    pkgs.rustc
    pkgs.clippy
    pkgs.zig

    pkgs.flutter
    pkgs.dart

    # For vim.lsp file watcher performance?
    pkgs.inotify-tools
  ];
  enableLuaLoader = true;

  withPython3 = true;
  withNodeJs = true;

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
    nvim-notify.enable = true;
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

      "remote-nvim.nvim" = {
        package = pkgs.vimPlugins.remote-nvim-nvim;
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
    };
  };
}
