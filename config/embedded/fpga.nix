{ nvimSize, pkgs, lib }: let

  enabled = nvimSize < 500;

in {
  extraPackages = lib.optionals enabled [
    pkgs.openfpgaloader

    pkgs.nextpnrWithGui
    pkgs.nextpnr-xilinx

    pkgs.yosys
    pkgs.sby
    pkgs.mcy

    # Extras
    pkgs.netlistsvg
  ];
}
