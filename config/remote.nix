{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 0;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.distant
  ];

  lazy = {
    plugins = {
      "remote-nvim.nvim" = {
        enabled = false;
        package = pkgs.vimPlugins.remote-nvim-nvim;

        setupOpts = {

        };

        lazy = true;
        event = [
          "BufEnter"
        ];
      };

      "distant.nvim" = {
        enabled = enableExtra;
          # Needs updates
          # https://github.com/myclevorname/distant
        package = pkgs.vimPlugins.distant-nvim;

        #setupModule = "distant";
        #setupOpts = {
        #  client = {
        #    bin = if enableExtra then "${lib.getExe pkgs.distant}" else "";
        #  };
        #};

        after = if enableExtra then /* lua */ ''
          local plugin = require('distant')
          plugin:setup({
            client = {
              bin = '${lib.getExe pkgs.distant}'
            }
          })
        '' else "";

        lazy = true;
        cmd = [
          "Distant"
          "DistantOpen"
          "DistantConnect"
          "DistantLaunch"
          "DistantInstall"
        ];
      };
    };
  };
}
