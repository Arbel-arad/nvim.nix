{ nvimSize, inputs, pkgs, lib }:{
  lsp = {
    enable = true;
    formatOnSave = false;

    lspconfig = {
      enable = true;
    };

    lspkind = {
      enable = true;
    };

    lspSignature = {
      enable = true;
    };

    inlayHints = {
      enable = true;
    };

    lspsaga = {
      enable = true;
      setupOpts = {
        ui = {
          code_action = "🟅";
        };
        lightbulb = {
          sign = false;
          virtual_text = true;
        };
        breadcrumbs = {
          enable = true;
        };
      };
    };

    trouble = {
      enable = true;
      mappings = {

      };
      setupOpts = {
        modes = {
          diagnostics = {
            auto_open = false;
            auto_close = false;
          };
        };
      };
    };

    otter-nvim = {
      enable = true;
      setupOpts = {
        buffers = {
          set_filetype = true;
        };
        lsp = {
          diagnostic_update_event = [
            "BufWritePost"
            "InsertLeave"
          ];
        };
      };
    };

    servers = {
      qmlls = {
        cmd = [
          "${pkgs.kdePackages.qtdeclarative}/bin/qmlls"
        ];
      };

      arduino-lsp = {
        cmd = [
          "${lib.getExe pkgs.arduino-language-server}"
          "-clangd" "${pkgs.clang-tools}/bin/clangd"
          "-cli" "${lib.getExe pkgs.arduino-cli}"
          "-fqbn" "arduino:avr:uno"
        ];

        filetypes = [
          "arduino"
          "ino"
        ];

        capabilities = lib.mkForce {

        };
      };

      zls = {
        root_markers = [
          ".git"
          "build.zig"
          "build.zig.zon"
        ];

        cmd = [
          "${lib.getExe pkgs.zls}"
          "--config-path"
          "${(pkgs.formats.json { }).generate "zls.json" {
            warn_style = true;
            #enable_build_on_save = true;
            build_on_save_args = [
              #"install"
              #  "-fno-emit-bin"
            ];
          }}"
        ];

        filetypes = [
          "zig"
          "zon"
        ];

        settings = {
          zls = {
            enable_build_on_save = true;
          };
        };
      };

      openscad = {
        root_markers = [
          ".git"
        ];

        cmd = [
          "${lib.getExe pkgs.openscad-lsp}"
          "--stdio"
        ];

        filetypes = [
          "openscad"
          "scad"
        ];
      };

      harper-ls = {
        root_markers = [
          ".git"
        ];

        cmd = [
          "${lib.getExe pkgs.harper}"
          "--stdio"
        ];

        #filetypes = [
        #"md"
        #];

        settings = {
          harper-ls = {
            linters = {
              spellCheck = true;
            };

            diagnosticSeverity = "hint";
            dialect = "American";
          };
        };
      };

      verible-verilog-ls = {
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

      fish-lsp = {
        cmd = [
          "${lib.getExe pkgs.fish-lsp}"
          "start"
        ];

        filetypes = [
          "fish"
        ];
      };

      systemd-lsp = {
        cmd = [
          "${lib.getExe pkgs.systemd-lsp}"
        ];

        filetypes = [
          "systemd"
        ];
      };

      awk-language-server = {
        cmd = [
          "${lib.getExe pkgs.awk-language-server}"
        ];

        filetypes = [
          "awk"
        ];
      };

      # Ruff python linter/LSP
      ruff = {
        cmd = [
          "${lib.getExe pkgs.ruff}"
          "server"
        ];

        filetypes = [
          "python"
        ];
      };
    };

    nvim-docs-view = {
      enable = false;
    };
  };
}
