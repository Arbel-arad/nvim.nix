{ nvimSize, pkgs, lib }: let
  enabled = nvimSize < 300;

  svlint_config = {
    textrules = {
      header_copyright = false;
    };

    syntaxrules = {
      # TODO: Make a new ruleset
      # Taken from https://github.com/dalance/svlint/blob/master/rulesets/verifintent.toml
      blocking_assignment_in_always_ff = true;
      non_blocking_assignment_in_always_comb = true;
      enum_with_type = true;
      keyword_forbidden_priority = true;
      keyword_forbidden_unique = true;
      keyword_forbidden_unique0 = true;
      procedural_continuous_assignment = true;
      action_block_with_side_effect = true;
      default_nettype_none = true;
      function_same_as_system_function = true;
      keyword_forbidden_wire_reg = true;
      module_nonansi_forbidden = true;
      localparam_type_twostate = true;
      parameter_type_twostate = true;
      localparam_explicit_type = true;
      parameter_explicit_type = true;
      parameter_default_value = true;
      parameter_in_generate = true;
      parameter_in_package = true;
      genvar_declaration_in_loop = true;
      genvar_declaration_out_loop = false;
      keyword_forbidden_generate = true;
      keyword_required_generate = false;
      multiline_for_begin = true;
      multiline_if_begin = true;
      inout_with_tri = true;
      input_with_var = true;
      output_with_var = true;
      interface_port_with_modport = true;
    };
  };

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

        cmd_env = {
          SVLINT_CONFIG = "${pkgs.writers.writeTOML ".svlint.toml" svlint_config}";
        };

        filetypes = [
          "verilog"
          "systemverilog"
        ];
      };

      veridian = lib.mkIf enabled {
        root_markers = [
          ".git"
          "verilator.f"
        ];

        cmd = [
          "${pkgs.veridian}/bin/veridian"
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
        # SVlint is integrated in svls

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
