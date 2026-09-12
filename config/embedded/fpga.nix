{ nvimSize, npins, pkgs, lib }: let

  enabled = nvimSize < 500;

  toolchains = import npins.fpga-toolchains {
    inherit pkgs lib;
  };

in {
    #FIXME: waiting for https://github.com/NixOS/nixpkgs/pull/561980
    #extraPackages = lib.optionals enabled (
    #  toolchains.packagesFor [
    #    "xilinx-XC7"
    #    "lattice-iCE40"
    #    "lattice-ECP5"
    #  ]
    #);
}
