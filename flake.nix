{
  description = "Arbel's neovim flake";

  outputs = { self, ... }@args: let

    npins = import ./npins;

    inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };

    overlays = import (self + /flake/overlays) {
      inherit self npins;
    };

    nixpkgs = {
      overlays = [
        overlays.common
        inputs.nvim-nightly.overlays.default
        inputs.rust-overlay.overlays.default
      ];

      config = {
        allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "telescope-sg"
          "scope.nvim"
          "barbar.nvim"
          "tree-sitter-http"
        ];
      };
    };

  in inputs.flake-parts.lib.mkFlake {
      inherit inputs;
      self = self // {
        inherit inputs;
      };
    } {
      imports = [
        "${npins.flake-parts-files}/flake-module.nix"
      ];

      flake = let

        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";

          inherit (nixpkgs) overlays config;
        };

      in {
        # For exploring configuration in REPL
        nvim-config = (import (self + /default.nix) {
          inherit self inputs pkgs;
          inherit (pkgs) lib;
          nvimConf = {
            size = 0;
          };
        }).config.programs.nvf.settings.vim;

        nvim-minimal-config = (import (self + /default.nix) {
          inherit self inputs pkgs;
          inherit (pkgs) lib;
          nvimConf = {
            size = 999;
          };
        }).config.programs.nvf.settings.vim;

        inherit pkgs npins inputs;

        nixosConfigurations = import ./flake/microVMs.nix {
          inherit inputs self pkgs;
        };
      };

      systems = inputs.system.wellSupportedArches;
      perSystem = { system, config, self', lib, ... }: let

        pkgs = import inputs.nixpkgs {
          inherit system;

          inherit (nixpkgs) overlays config;
        };

      in {
        devShells = let

          defaultPackages = [
            config.files.writer.drv

            self'.packages.default
            self'.packages.nvim-gui
            self'.packages.nvim-zellij

            pkgs.attic-client
            pkgs.nix-tree
            pkgs.npins
            pkgs.tack
            pkgs.just
            pkgs.bat
          ];

          # Automatically write file
          shellHook = /* bash */ ''
            write-files
          '';

        in {
          default = pkgs.mkShell {
            inherit shellHook;
            nativeBuildInputs =
              self.nvim-config.extraPackages
              ++ defaultPackages;
          };

          minimal = pkgs.mkShell {
            inherit shellHook;
            nativeBuildInputs =
              self.nvim-minimal-config.extraPackages
              ++ defaultPackages;
          };
        };

        packages = import ./flake/packages {
          inherit config inputs self self' pkgs lib;
          nvf-pkgs = import inputs.nixpkgs {
            inherit system;

            overlays = [
              overlays.common
              overlays.nvf-pkgs
            ];
          };
        };

        apps = import ./flake/apps.nix {
          inherit self self' pkgs;
        };

        files = {
          file = {
            ".luarc.json".source = (pkgs.formats.json {}).generate ".luarc.json" {
              "workspace.library" = [
                "${pkgs.neovim-unwrapped}/share/nvim/runtime"
                ''''${3rd}/luv/library''
              ];

              "diagnostics.globals" = [
                "read_globals"
              ];
            };
          };
        };
      };
    };


  nixConfig = {

    extra-substituters = [
      "http://buildnix.spacetime.technology:8000"
      "https://attic.spacetime.technology/buildnix"
    ];
    extra-trusted-public-keys = [
      "buildnix.spacetime.technology:cUI+2I7OJ/ufQg6Or2NP7mzPwdLQ7LUny80UxyFr25A="
      "buildnix:qoIQsNnowGUD+xY+ULAtgp0tRXpEi4JO0191uHu869E="
    ];

  };
}
