{ npins, pkgs }: {
  lazy = {
    plugins = {
      "just.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "just.nvim";
          version = "0";

          src = npins."just.nvim";

          dependencies = [
            pkgs.vimPlugins.plenary-nvim
            pkgs.vimPlugins.fidget-nvim
          ];

          doCheck = true;

          nvimSkipModules = [
            #"just"
          ];
        };


        setupModule = "just";
        setupOpts = {
          open_qf_on_error = true;
          open_qf_on_run = true;
          open_qf_on_any = true;
          autoscroll_qf = true;
          register_commands = true;
        };

        lazy = true;

        cmd = [
          "Just"
          "JustSelect"
          "JustStop"
          "JustCreateTemplate"
        ];
      };
    };
  };
}
