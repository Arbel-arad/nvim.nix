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

        #TODO: modify this for IPv6 support
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

          require("live-share.provider").register("lan", {
            command = function(_, port, service_url)
              return string.format(
                [[printf 'tcp://127.0.0.1:%d\n' > %s; sleep infinity]],
                port, service_url)
            end,
            pattern = "tcp://[%w._-]+:%d+",
          })
        '';

        setupModule = "live-share";
        setupOpts = {
          openssl_lib = "${pkgs.rustls-libssl}/lib/libcrypto.so";

          #service = "bore";
          service = "lan";

          username = "Arbel";
          ip_local = "127.0.0.1";
        };

        lazy = true;

        cmd = [
          "LiveShareHostStart"
          "LiveShareJoin"
          "LiveShareStop"
          "LiveShareTerminal"
          "LiveShareWorkspace"
          "LiveShareOpen"
          "LiveShareFollow"
          "LiveShareUnfollow"
          "LiveSharePeers"
          #"LiveShareDebugInfo"
        ];
      };
    };
  };
}
