{ pkgs, lib }:{
  keymaps = [
    {
      key = "<leader>tt";
      mode = [
        "n"
      ];
      silent = true;
      action = "<cmd>Lspsaga term_toggle ${lib.getExe pkgs.fish}<cr>";
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
  ];

  binds = {
    whichKey = {
      enable = true;
    };
    cheatsheet = {
      enable = true;
    };
  };
}
