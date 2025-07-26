{ pkgs, lib }:{
  extraPlugins = {
    nvim-orgmode = {
      package = pkgs.vimPlugins.orgmode;
    };
  };
  pluginRC = {
    orgmode = /* lua */ ''
      -- Treesitter configuration
      require('nvim-treesitter.configs').setup {

        -- If TS highlights are not enabled at all, or disabled via `disable` prop,
        -- highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          -- Required for spellcheck, some LaTex highlights and
          -- code block highlights that do not have ts grammar
          additional_vim_regex_highlighting = {'org'},
        },
      }
    '';
  };
  treesitter = {
    grammars = [
      pkgs.luajitPackages.tree-sitter-orgmode
    ];
  };
}
