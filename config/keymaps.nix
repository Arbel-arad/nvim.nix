_:{
  keymaps = [
    {
      key = "<leader>tt";
      mode = ["n"];
      silent = true;
      action = "<cmd>Lspsaga term_toggle<cr>";
      desc = "Lspsaga terminal";
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
