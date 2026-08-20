{ pkgs, nixpkgs }: let

  pkgs-nrf = import nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;

    config = {
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
        "nrf-command-line-tools"
        "nrfutil"
        "nrfutil-completion"

        "segger-jlink"
      ];

      permittedInsecurePackages = [
        "segger-jlink-qt4-952"
      ];

      segger-jlink.acceptLicense = true;
    };
  };

in {
  extraPackages = [
    pkgs-nrf.nrf-command-line-tools
    pkgs-nrf.nrfutil
  ];
}
