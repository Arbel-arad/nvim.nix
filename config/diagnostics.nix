{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 400;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.vale
  ];

  diagnostics = {
    enable = true;

    config = {
      signs = {
        text = lib.generators.mkLuaInline /* lua */ ''
          {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          }
      '';
      };
      underline = true;
      update_in_insert = true;

      virtual_text = {
        # current_line causes "flickering" when there are multiple entries on the same line
        current_line = false;

        severity = {
          min = lib.generators.mkLuaInline /* lua */ ''
            vim.diagnostic.severity.WARN
          '';
        };

        #format = lib.generators.mkLuaInline /* lua */ ''
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
        #format = lib.generators.mkLuaInline /* lua */ ''
        #  function(diagnostic)
        #    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
        #    if diagnostic.lnum == cursor_line then
        #      return string.format("%s", diagnostic.message)
        #    end
        #  end
        #'';
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

        # verilog linter
        verilator = {
          cmd = if enableExtra then "${pkgs.verilator}/bin/verilator" else "false";

          args = [
            "-sv"
            "-wall"
            "--bbox-sys"
            "--bbox-unsup"
            "--lint-only"
            "-f"
            (lib.generators.mkLuaInline /* lua */ ''
              vim.fs.find('verilator.f', {upward = true, stop = vim.env.HOME})[1]
            '')
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
        systemverilog = [
          "verilator"
        ];
        verilog = [
          "verilator"
        ];
      };
    };
  };
}
