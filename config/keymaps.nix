{ pkgs, lib }:{
  keymaps = [
    {
      key = "<leader>tt";
      mode = ["n"];
      silent = true;
      action = "<cmd>Lspsaga term_toggle ${lib.getExe pkgs.fish}<cr>";
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
