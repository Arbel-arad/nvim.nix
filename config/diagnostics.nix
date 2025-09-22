{ nvimSize, lib }:{
  diagnostics = {
    enable = true;
    config = {
      signs = {
        text = {
          "vim.diagnostic.severity.Error" = " ";
          "vim.diagnostic.severity.Warn" = " ";
          "vim.diagnostic.severity.Hint" = " ";
          "vim.diagnostic.severity.Info" = " ";
        };
      };
      underline = true;
      update_in_insert = true;

      virtual_text = {
        format = lib.generators.mkLuaInline /* lua */ ''
          function(diagnostic)
            local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
            if diagnostic.lnum ~= cursor_line then
              return string.format("%s", diagnostic.message)
            end
          end
        '';
      };
      virtual_lines = {
        format = lib.generators.mkLuaInline /* lua */ ''
          function(diagnostic)
            local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
            if diagnostic.lnum == cursor_line then
              return string.format("%s", diagnostic.message)
            end
          end
        '';
      };
    };
    nvim-lint = {
      enable = true;
      linters = {

      };
      linters_by_ft = {
        c = [
          "cppcheck"
        ];
      };
    };
  };
}
