{ nvimSize, pkgs, lib }: let
  enabled = nvimSize < 300;


in {
  lsp = {
    servers = {
      verible-verilog-ls = lib.mkIf enabled {
        root_markers = [
          ".git"
          "verilator.f"
        ];

        cmd = [
          "${pkgs.verible}/bin/verible-verilog-ls"
          # Fixes double notification issue
          "--nopush_diagnostic_notifications"
        ];

        filetypes = [
          "verilog"
          "systemverilog"
        ];
      };

      svls = lib.mkIf enabled {
        root_markers = [
          ".git"
          "verilator.f"
        ];

        cmd = [
          "${pkgs.svls}/bin/svls"
        ];

        filetypes = [
          "verilog"
          "systemverilog"
        ];
      };
    };
  };

  diagnostics = {
    nvim-lint = {
      linters = {
        verilator = {
          cmd = if enabled then "${pkgs.verilator}/bin/verilator" else "false";

          args = [
            "-sv"
            "-wall"
            "--bbox-sys"
            "--bbox-unsup"
            "--lint-only"
            "-f"

            (lib.generators.mkLuaInline /* Lua */ ''
              vim.fs.find('verilator.f', {upward = true, stop = vim.env.HOME})[1]
            '')
          ];
        };
      };

      linters_by_ft = {
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
