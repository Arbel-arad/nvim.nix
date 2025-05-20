{
  description = "Arbel's neovim flake";

  inputs = {
    nixpkgs.url = "git+https://forgejo.spacetime.technology/nix-mirrors/nixpkgs?ref=nixpkgs-unstable&shallow=1";
    flake-parts.url = "git+https://forgejo.spacetime.technology/nix-mirrors/flake-parts?shallow=1";
    system.url = "git+https://forgejo.spacetime.technology/arbel/nix-system?shallow=1";
    nvim-nightly = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/neovim-nightly-overlay?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "git+https://forgejo.spacetime.technology/nix-mirrors/nvf?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs self; } {
  flake = {

  };
  systems = inputs.system.wellSupportedArches;
    perSystem = { config, self', pkgs, lib, ... }: {
      devShells = {
        default = pkgs.mkShell {
        };
      };
      packages = import ./package.nix { inherit config inputs self' pkgs lib; };
      apps = import ./apps.nix { inherit self' pkgs; };
    };
  };
}
