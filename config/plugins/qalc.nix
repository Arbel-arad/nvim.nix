{ npins, pkgs }: {
  extraPackages = [
    pkgs.libqalculate
  ];

  lazy = {
    plugins = {
      "qalc.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "qalc.nvim";
          version = "0";

          src = npins."qalc.nvim";
        };

        setupModule = "qalc";
        setupOpts = {

        };
      };
    };
  };
}
