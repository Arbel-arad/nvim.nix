{ nvf, pkgs, lib }:{
  keymaps = [
    # Terminals
    {
      key = "<leader>tt";
      mode = [
        "n"
      ];
      silent = true;
      action = "<cmd>Lspsaga term_toggle fish<cr>";
      desc = "Lspsaga terminal";
    }
    {
      key = "<leader>ta";
      mode = [
        "n"
      ];
      silent = true;
      action = /* lua */ "<cmd>lua Snacks.terminal.open()<cr>";
      desc = "Open new terminal";
    }

    # Search
    # set hlsearch/nohlsearch for highlighting
    {
      #key = "<ESC><ESC>";
      key = "<leader>q";
      mode = [
        "n"
      ];
      silent = true;
      action = ":nohl<CR><C-l>";
      desc = "Clear search highlight";
    }
  ];
  binds = let

    inherit (nvf.lib.nvim.binds) pushDownDefault;

  in {
    whichKey = {
      enable = true;

      # Add whichkey groups for test and debug runners
      register = pushDownDefault {
        "<leader>r" = "+Run";
        "<leader>rt" = "+Run test";
        "<leader>rd" = "+Run debug";
      };
    };

    cheatsheet = {
      enable = true;
    };
  };
}
