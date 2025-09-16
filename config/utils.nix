{ pkgs }:{
  clipboard = {
    enable = true;
    providers = {
      wl-copy.enable = true;
    };
  };

  spellcheck = {
    enable = true;
    languages = [
      "en"
      "he"
    ];
    programmingWordlist.enable = true;
  };

  utility = {
    direnv = {
      #enable = true; # still uses old direnv.vim
    };
  };

  notes = {
    todo-comments = {
      enable = true;
    };
    orgmode = {
      enable = true;
      treesitter = {
        enable = true; # need to find the right package
        orgPackage = pkgs.luajitPackages.tree-sitter-orgmode;
      };
    };
  };
}
