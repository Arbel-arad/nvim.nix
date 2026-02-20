{ pkgs }: {
  lazy = {
    plugins = {
      "hlchunk.nvim" = {
        package = pkgs.vimPlugins.hlchunk-nvim;

        setupModule = "hlchunk";
        setupOpts = {
          chunk = {
            enable = true;

            chars = {
              horizontal_line = "─";
              vertical_line = "│";
              left_top = "╭";
              left_bottom = "╰";
              # TODO: replace with pipe arrow character
              right_arrow = "─";
            };

            style = [
              {
              fg = "#008f8f";
              }
              {
              fg = "#ff6f6f";
              }
            ];

            # Disable animation
            delay = 0;
          };

          indent = {
            enable = true;

            #use_treesitter = true;
          };
        };

        lazy = true;

        event = [
          "BufEnter"
        ];
      };
    };
  };
}
