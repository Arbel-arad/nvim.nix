{ pkgs, lib }: {
  globals = {
    instant_username = lib.mkDefault "arbel";
  };

  extraPackages = [
    pkgs.bore-cli
  ];

  lazy = {
    plugins = {
      "instant.nvim" = {
        package = pkgs.vimPlugins.instant-nvim;

        setupOpts = { };

        lazy = true;

        cmd = [
          #"InstantStart"
          #"InstantJoin"
          "InstantStop"
          "InstantStatus"
          "InstantFollow"
          "InstantStopFollow"
          "InstantOpenAll"
          "InstantSaveAll"
          "InstantMark"
          "InstantMarkClear"

          "InstantStartSingle"
          "InstantStartSession"

          "InstantJoinSingle"
          "InstantJoinSession"

        ];
      };

      "live-share.nvim" = {
        package = pkgs.vimPlugins.live-share-nvim;

        beforeSetup = /* Lua */ ''
          require("live-share.provider").register("bore", {
            command = function(_, port, service_url)
              return string.format(
                "bore local %d --to bore.pub > %s 2>/dev/null",
                port,
                service_url
              )
            end,
            pattern = "bore%.pub:%d+",
          })
        '';

        setupModule = "live-share";
        setupOpts = {
          service = "bore";
        };

        lazy = true;

        cmd = [
          "LiveShareServer"
          "LiveShareJoin"
        ];
      };
    };
  };
}
