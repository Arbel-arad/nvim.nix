{
  description = "Arbel's neovim flake";

  inputs = {
    #nixpkgs.url = "git+https://forgejo.spacetime.technology/nix-mirrors/nixpkgs?ref=master&shallow=1";
    nixpkgs.url = "git+https://github.com/nixos/nixpkgs?rev=97c8a41d0dda5063b4e42f4ddf6a850da2688037&shallow=1";
    flake-parts.url = "git+https://forgejo.spacetime.technology/nix-mirrors/flake-parts?shallow=1";
    system.url = "git+https://forgejo.spacetime.technology/arbel/nix-system?shallow=1";
    nvim-nightly = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/neovim-nightly-overlay?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nvf = {
      #url = "git+https://forgejo.spacetime.technology/nix-mirrors/nvf?shallow=1";
      url = "github:arbel-arad/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    spectrum-os = {
      url = "git+https://forgejo.spacetime.technology/mirrors/spectrum-os?shallow=1";
      flake = false;
    };

    microvm = {
      url = "git+https://forgejo.spacetime.technology/arbel/microvm.nix?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        spectrum.follows = "spectrum-os";
      };
    };

    lsp-inputs = {
      url = "git+https://forgejo.spacetime.technology/arbel/nix-lsp-inputs?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        system.follows = "system";
      };
    };

    rustowl-flake = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/rustowl-flake.git?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs = { self, ... }@inputs: let

    overlays = import (self + /flake/overlays.nix) {
      inherit self;
    };

  in inputs.flake-parts.lib.mkFlake {
      inherit inputs self;
    } {
      flake = let

        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";

          overlays = [
            overlays.nvf-pkgs
          ];
        };

      in {
        # For exploring configuration in REPL
        nvim-config = (import (self + /default.nix) {
          inherit inputs pkgs;
          inherit (pkgs) lib;
          config = { };
        }).config.programs.nvf.settings.vim;

        inherit pkgs;

        nixosConfigurations = import ./flake/microVMs.nix {
          inherit inputs self;
        };
      };

      systems = inputs.system.wellSupportedArches;
      perSystem = { system, config, self', lib, ... }: let

        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            overlays.nvf-pkgs
          ];
        };

      in {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              self.nvim-config.extraPackages

              self'.packages.default
              self'.packages.nvim-gui
              self'.packages.nvim-zellij

              pkgs.attic-client
              pkgs.nix-tree
              pkgs.npins
              pkgs.just
              pkgs.bat
            ];
          };
        };

        packages = import ./flake/package.nix {
          inherit config inputs self self' pkgs lib;
          nvf-pkgs = import inputs.nixpkgs {
            inherit system;

            overlays = [
              overlays.nvf-pkgs
            ];
          };
        };

        apps = import ./flake/apps.nix {
          inherit self self' pkgs;
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
      "buildnix:Ns8cOyVRHbn/FIui31sgg7b0LG4wNl+GmcOdTw8B73o="
    ];

  };
}
