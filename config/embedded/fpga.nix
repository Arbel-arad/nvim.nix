{ nvimSize, npins, pkgs, lib }: let

  enabled = nvimSize < 500;

  toolchains = import npins.fpga-toolchains { inherit pkgs lib; };

in {
  extraPackages = lib.optionals enabled ([
    pkgs.openfpgaloader

    pkgs.nextpnrWithGui
    pkgs.nextpnr-xilinx

    pkgs.yosys
    pkgs.sby
    pkgs.mcy

    pkgs.apio

    # Extras
    pkgs.netlistsvg
  ] ++ toolchains.packagesFor [
      "xilinx-XC7"
      "lattice-iCE40"
      "lattice-ECP5"
  ]);
}
