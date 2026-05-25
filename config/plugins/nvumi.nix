{ pkgs, npins }: let
  # Freeform unit conversion

  inherit (npins) nvumi;

in {
  extraPackages = [
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
      nvumi = {
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
