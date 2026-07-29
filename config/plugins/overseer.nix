{ pkgs }: {
  lazy = {
    plugins = {
      "overseer.nvim" = {
        package = pkgs.vimPlugins.overseer-nvim;

        setupModule = "overseer";
        setupOpts = {

        };
      };
    };
  };
}
