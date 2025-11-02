{ nvimSize, pkgs, lib }:{
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
        # openSCAD linter
        sca2d = {
          cmd = lib.getExe pkgs.sca2d;

          stdin = false;
          append_fname = true;

          stream = "both";

          ignore_exitcode = true;

          parser = lib.generators.mkLuaInline /* lua */ ''
            function(output, bufnr)
              local diagnostics = {}
              local lines = vim.split(output, "\n", { trimempty = true })

              for idx, line in ipairs(lines) do
                local filename, lnum, col, code, msg = line:match("^([^:]+):(%d+):(%d+):%s*([IWEFU]%d+):%s*(.+)")
                if filename and lnum and col and code and msg then
                  -- Default severity: Error unless Info or Warning
                  local severity = vim.diagnostic.severity.ERROR
                  if code:sub(1, 1) == "I" or code:sub(1, 1) == "W" then
                    severity = vim.diagnostic.severity.WARN
                  end

                  -- Check for better location hints in next line
                  if code:sub(1, 1) == "F" and lines[idx + 1] then
                    local syn_line, syn_col = lines[idx + 1]:match("at line (%d+) col (%d+)$")
                    if syn_line and syn_col then
                      lnum = syn_line
                      col = syn_col
                    end
                  end

                  table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = tonumber(col) - 1,
                    end_lnum = tonumber(lnum) - 1,
                    end_col = tonumber(col),
                    message = msg,
                    source = "sca2d",
                    severity = severity,
                    code = code,
                  })
                end
              end

              return diagnostics
            end
          '';
        };

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
        openscad = [
          "sca2d"
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
