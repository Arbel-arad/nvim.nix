{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 100;
in {
  extraPackages = lib.optionals enabled [
    # For micropython
    pkgs.rshell
    pkgs.adafruit-ampy

    pkgs.platformio-core
  ];

  lazy = {
    plugins = {
      "nvim-platformio" = {
        inherit enabled;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-platformio";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "anurag3301";
            repo = "nvim-platformio.lua";
            rev = "a8245f0243c80c2635103863f64c839b9a2d88a0";
            hash = "sha256-iid6GdLSWr7cDqkYpRp9vR7TKJJzfp/tAYUACPOXLIc=";
          };

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

      "arduino-nvim" = {
        enabled = false;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "arduino-nvim";
          version = "0";
          src = pkgs.fetchFromGitHub {
            owner = "glebzlat";
            repo = "arduino-nvim";
            rev = "086901d0b33a330c2f6e3fe2095ad8166c093e88";
            hash = "sha256-OHMMV4Bg+3k8BfvVJ0Cz42SX31dsdwfAYJ6w5IPfWyo=";
          };

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

      "nvim-arduino" = {
        enabled = false;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-arduino";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "yuukiflow";
            repo = "Arduino-Nvim";
            rev = "fba550deef2acf2b400927e82775d5139c56615f";
            hash = "sha256-0jord5abDVqU5NhlW0LhKrKdgXX1/hJlM0W0ByRXyb4=";
          };

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

          src = pkgs.fetchFromGitHub {
            owner = "jim-at-jibba";
            repo = "micropython.nvim";
            rev = "c1c7f5b4133391ff61b5ae87731caec6d77f377f";
            hash = "sha256-N9od+q5T42Dm09Vc4y5c2X5OqZ4RPL0mqvVUXwLsLFA=";
          };

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
