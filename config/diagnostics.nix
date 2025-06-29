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
        format = lib.generators.mkLuaInline /* lua */''
          function(diagnostic)
            return string.format("%s", diagnostic.message)
            --return string.format("%s (%s)", diagnostic.message, diagnostic.source)
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
