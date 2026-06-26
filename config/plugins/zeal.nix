{ nvimSize, npins, pkgs, lib }: let

  enabled = nvimSize <= 10;

  zeal-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "zeal-nvim";
    version = "0";

    src = npins."zeal.nvim";

    patches = [
      #./patches/zeal-ro.patch
    ];
  };

in {
  extraPackages = lib.optionals enabled [
    pkgs.w3m-nox
    pkgs.sqlite
  ];

  lazy = {
    plugins = {
      zeal-nvim = lib.mkIf enabled {
        package = zeal-nvim;

        setupModule = "zeal";
        setupOpts = {

          use_toggleterm = true;

          picker = {
            type = "snacks";
          };
        };

        lazy = true;
        cmd = [
          "Zeal"
          "ZealSearchFt"
          "ZealToggle"
        ];
      };
    };
  };
}
