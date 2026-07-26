{ inputs, nvimSize, pkgs, lib }: let

  inherit (pkgs.stdenv.hostPlatform) system;

  enabled = nvimSize <= 200;

in {
  extraPackages = lib.optionals enabled [
    inputs.build123d.packages.${system}.tools
  ];
}
