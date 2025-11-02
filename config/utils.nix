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
      #"he"
    ];
    programmingWordlist = {
      #enable = true;
    };
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
    neorg = {
      enable = true;
      treesitter = {
        enable = true;
      };
      setupOpts = {
        load = {
          "core.defaults" = {
            enable = true;
          };
          "core.concealer" = {
            enable = true;
            config = {

            };
          };
          "core.completion" = {
            enable = true;
            config = {
              engine = "nvim-cmp";
            };
          };
        };
      };
    };
  };
}
