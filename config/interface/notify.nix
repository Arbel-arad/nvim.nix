{ lib }: {

  notify = {
    nvim-notify = {
      enable = true;
    };
  };

  visuals = {
    fidget-nvim = {
      enable = true;

      setupOpts = {

        progress = {
          # Disable repeated hot-reload LSP notifications
          suppress_on_insert = true;
        };
      };
    };
  };

  lazy = {
    plugins = {
      fidget-nvim = {
        cmd = [
          "Fidget"
        ];
      };
    };
  };
}
