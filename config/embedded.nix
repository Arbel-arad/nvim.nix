{ nvimSize, npins, pkgs, lib }: let

  enabled = nvimSize <= 100;

in {
  extraPackages = lib.optionals enabled [
    # For micropython
    pkgs.rshell
    pkgs.adafruit-ampy

    # Generic embedded project framework
    pkgs.platformio-core

    # For teensy boards
    pkgs.tytools

    # For embedded rust
    pkgs.probe-rs-tools
    pkgs.ravedude
    pkgs.espflash

    pkgs.minicom
    pkgs.tio

    # For debugging
    pkgs.openocd
    pkgs.pyocd
    #pkgs.blackmagic
  ];

  lazy = {
    plugins = if !enabled then {} else {
      "nvim-platformio" = lib.mkIf enabled {
        inherit enabled;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-platformio";
          version = "0";

          src = npins."nvim-platformio.lua";

          dependencies = [
            pkgs.vimPlugins.telescope-nvim
            pkgs.vimPlugins.telescope-ui-select-nvim
            pkgs.vimPlugins.FTerm-nvim
            pkgs.vimPlugins.plenary-nvim
            pkgs.vimPlugins.toggleterm-nvim
            pkgs.vimPlugins.which-key-nvim
            pkgs.platformio-core
          ];

          doCheck = true;

          nvimSkipModules = [
            "minimal_config"
            "platformio.piolsserial"
            "platformio.boilerplate"
            "platformio"
            "platformio.piocmd"
            "platformio.piodebug"
            "platformio.pioinit"
            "platformio.piolib"
            "platformio.piolsp"
            "platformio.piomenu"
            "platformio.piomon"
            "platformio.piorun"
            "platformio.utils"
            "platformio.health"
            "health.platformio"
            "vim.health.platformio"
          ];
        };

        setupOpts = {
          lsp = "clangd";
        };

        lazy = true;

        cmd = [
          "Pioinit"
          "Piorun"
          "Piocmdh"
          "Piocmdf"
          "Piolib"
          "Piomon"
          "Piodebug"
          "Piodb"
        ];
      };

      "arduino-nvim" = lib.mkIf enabled {
        enabled = false;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "arduino-nvim";
          version = "0";

          src = npins."arduino-nvim";

          dependencies = [
            pkgs.clang-tools
            pkgs.arduino-cli
            pkgs.arduino-language-server
          ];

          doCheck = true;
        };
        setupOpts = {
          clangd = "${pkgs.clang-tools}/bin/clangd";
          arduino = "${lib.getExe pkgs.arduino-cli}";
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false;
                lineFoldingOnly = true;
              };
            };
          };
        };

        lazy = true;

        ft = [
          "ino"
        ];

      };

      "nvim-arduino" = lib.mkIf enabled {
        enabled = false;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-arduino";
          version = "0";

          src = npins."Arduino-Nvim";

          dependencies = [
            pkgs.clang-tools
            pkgs.arduino-cli
            pkgs.arduino-language-server
            pkgs.vimPlugins.telescope-nvim
            pkgs.vimPlugins.nvim-lspconfig
          ];

          doCheck = true;

          nvimSkipModules = [
            "init"
            "libGetter"
          ];
        };

        lazy = false;
      };

      "micropython.nvim" = {
        inherit enabled;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "micropython.nvim";
          version = "0";

          src = npins."micropython.nvim";

          dependencies = [
            pkgs.vimPlugins.toggleterm-nvim
            pkgs.rshell
            pkgs.adafruit-ampy
          ];

          doCheck = true;
        };

        lazy = true;

        cmd = [
          "MPRun"
          "MPSetPort"
          "MPSetBaud"
          "MPSetStubs"
          "MPRepl"
          "MPInit"
          "MPUpload"
          "MPEraseOne"
          "MPUploadAll"
        ];
      };
    };
  };
}
