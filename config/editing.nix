{ pkgs }:{
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
