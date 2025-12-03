{ nvimSize, pkgs, lib }:{
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

        # verilog linter
        verilator = {
          cmd = "${pkgs.verilator}/bin/verilator";

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

        # zig zlint
        zlint = {
          cmd = "${lib.getExe pkgs.zig-zlint}";
        };
      };
      linters_by_ft = {
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
        zig = [
          "zlint"
        ];
      };
    };
  };
}
