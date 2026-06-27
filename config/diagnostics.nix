{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 400;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.vale
  ];

  diagnostics = {
    enable = true;

    config = {
      underline = true;
      severity_sort = true;
      update_in_insert = true;

      signs = {
        text = lib.generators.mkLuaInline /* Lua */ ''
          {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          }
      '';
      };

      virtual_text = {
        # current_line causes "flickering" when there are multiple entries on the same line
        current_line = false;

        severity = {
          min = lib.generators.mkLuaInline /* Lua */ ''
            vim.diagnostic.severity.ERROR
          '';
        };

        #format = lib.generators.mkLuaInline /* Lua */ ''
        #  function(diagnostic)
        #    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
        #    if diagnostic.lnum ~= cursor_line then
        #      return string.format("%s", diagnostic.message)
        #    end
        #  end
        #'';
      };
      virtual_lines = {
        current_line = true;
        #format = lib.generators.mkLuaInline /* Lua */ ''
        #  function(diagnostic)
        #    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
        #    if diagnostic.lnum == cursor_line then
        #      return string.format("%s", diagnostic.message)
        #    end
        #  end
        #'';
      };

      float = {
        source = "always";
        border = "rounded";
      };
    };

    nvim-lint = {
      enable = true;

      linters = {
        # Writing style linter
        vale = {
          # Require vale configuration before running
          required_files = [
            ".vale.ini"
          ];
        };
      };

      linters_by_ft = {
        org = [
          "vale"
        ];
        markdown = [
          "vale"
        ];
        c = [
          "cppcheck"
        ];
        cpp = [
          "cppcheck"
        ];
      };
    };
  };
}
