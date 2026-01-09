{ nvimSize, inputs, pkgs, lib }: let

  enableExtra = nvimSize <= 300;

in {
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
      # blink-cmp has an integrated replacement
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
          enable = false;
        };

        symbol_in_winbar = {
          enable = false;
        };
      };
    };

    trouble = {
      enable = true;
      mappings = {

      };
      setupOpts = {
        win = {
          type = "split";
          position = "right";
        };

        modes = {
          diagnostics = {
            auto_open = false;
            auto_close = false;
          };
        };
      };
    };

    servers = {
      qmlls = lib.mkIf enableExtra {
        cmd = [
          "${pkgs.kdePackages.qtdeclarative}/bin/qmlls"
        ];
      };

      arduino-lsp = lib.mkIf (nvimSize <= 300) {
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

      harper-ls = lib.mkIf enableExtra {
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

      verible-verilog-ls = lib.mkIf enableExtra {
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

      fish-lsp = lib.mkIf enableExtra {
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

      awk-language-server = lib.mkIf enableExtra {
        cmd = [
          "${lib.getExe pkgs.awk-language-server}"
        ];

        filetypes = [
          "awk"
        ];
      };

      lua-language-server = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT";
            };

            workspace = {
              checkThirdParty = false; # ?
              library = [
                # This might be better defined per project
                # (.luarc.jsonc)
                (lib.generators.mkLuaInline /* lua */ "vim.env.VIMRUNTIME")
              ];
            };

            diagnostics = {
              globals = [
                #"vim"
              ];
            };
          };
        };
      };
    };

    nvim-docs-view = {
      enable = false;
    };
  };
}
