{ nvimSize, npins, pkgs, lib }: let
  # Freeform unit conversion

  enabled = nvimSize <= 100;
  inherit (npins) nvumi;

in {
  extraPackages = lib.optionals enabled [
    (pkgs.symlinkJoin {
      name = "numr-numi";

      paths = [
        pkgs.numr
      ];

      postBuild = /* bash */ ''
        ln -s "$out/bin/numr" "$out/bin/numi"
        ln -s "$out/bin/numr-cli" "$out/bin/numi-cli"
      '';
    })
  ];

  lazy = {
    plugins = {
      nvumi = lib.mkIf enabled {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvumi";
          version = nvumi.revision;

          src = nvumi;
        };

        setupModule = "nvumi";
        setupOpts = {

        };
      };
    };
  };
}
