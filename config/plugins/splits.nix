{ npins, pkgs, lib }: let

  vim-zellij-navigator-broken = let

    src = npins."vim-zellij-navigator";

  in pkgs.rustPlatform.buildRustPackage {
    name = "vim-zellij-navigator";
    version = "0";

    inherit src;

    cargoLock = {
      lockFile = src + /Cargo.lock;
    };

    buildInputs = [
      pkgs.openssl
    ];

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    env = {
      PKG_CONFIG_PATH = lib.getExe pkgs.pkg-config;
    };
  };

  vim-zellij-navigator = builtins.path {
    name = "vim-zellij-navigator";

    path = builtins.fetchurl {
      url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
      sha256 = "13f54hf77bwcqhsbmkvpv07pwn3mblyljx15my66j6kw5zva5rbp";
    };
  };

in {

  config = {
    utility = {
      smart-splits = {
        enable = true;

        keymaps = {
          resize_left = "<A-h>";
          resize_down = "<A-j>";
          resize_up = "<A-k>";
          resize_right = "<A-l>";
          move_cursor_left = "<C-A-h>";
          move_cursor_down = "<C-A-j>";
          move_cursor_up = "<C-A-k>";
          move_cursor_right = "<C-A-l>";
          move_cursor_previous = "<C-A-\\>";
        };

        setupOpts = {
          multiplexer_integration = "zellij";
          zellij_move_focus_or_tab = true;
        };
      };
    };

    autocmds = [
      {
        event = [
          "FocusGained"
          "UIEnter"
        ];
        pattern = [
          "*"
        ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            if vim.env.ZELLIJ == "0" then
              vim.cmd("silent !zellij action switch-mode locked")
            end
            --vim.notify("enter")
          end
        '';
      }
      {
        event = [
          "FocusLost"
          "UILeave"
        ];
        pattern = [
          "*"
        ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            if vim.env.ZELLIJ == "0" then
              vim.cmd("silent !zellij action switch-mode normal")
            end
            --vim.notify("leave")
          end
        '';
      }
    ];
  };
}
