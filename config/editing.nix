{ nvimSize, pkgs }:{
  autocomplete = { # Which is better?
    nvim-cmp = {
      enable = true;
      sources = {
        buffer = "[Buffer]";
        nvim-cmp = null;
        path = "[Path]";
      };
      sourcePlugins = [
        pkgs.vimPlugins.cmp-cmdline
      ];
    };
    blink-cmp = {
      enable = false;
    };
  };

  treesitter = {
    enable = true;
    addDefaultGrammars = true;
    context = {
      enable = false;
      setupOpts = {
        #multiwindow = true;
        mode = "topline";
        max_lines = 3;
        min_window_height = 50;
        separator = null;
        zindex = 10;
      };
    };
    autotagHtml = true;
    highlight = {
      enable = true;
    };
    indent = {
      enable = true;
      disable = [
        #"nix"
      ];
    };
    textobjects = {
      enable = true;
    };
  };

  telescope = {
    enable = true;
    mappings = {

    };
  };

  autopairs = {
    nvim-autopairs = {
      enable = true;
    };
  };

  snippets = {
    luasnip = {
      enable = true;
    };
  };
}
