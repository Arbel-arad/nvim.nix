{
  description = "Arbel's neovim flake";

  inputs = {
    nixpkgs.url = "git+https://forgejo.spacetime.technology/nix-mirrors/nixpkgs?ref=nixpkgs-unstable&shallow=1";
    flake-parts.url = "git+https://forgejo.spacetime.technology/nix-mirrors/flake-parts?shallow=1";
    system.url = "git+https://forgejo.spacetime.technology/arbel/nix-system?shallow=1";
    nvim-nightly = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/neovim-nightly-overlay?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nvf = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/nvf?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
  };

  outputs = { self, ... }@inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs self; } {
  flake = {
    nixosConfigurations = import ./flake/microVMs.nix {
      inherit inputs self;
    };
  };
  systems = inputs.system.wellSupportedArches;
    perSystem = { config, self', pkgs, lib, ... }: {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            self'.packages.default
            pkgs.nix-tree
            pkgs.just
          ];
        };
      };
      packages = import ./flake/package.nix { inherit config inputs self self' pkgs lib; };
      apps = import ./flake/apps.nix { inherit self self' pkgs; };
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
