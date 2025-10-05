{ nvimSize, pkgs, lib }:{
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
      nil = {
        enable = true;
        cmd = [ "${lib.getExe pkgs.nil}" ];
        filetypes = [
          "nix"
        ];
        root_markers = [
          "flake.nix"
          "flake.lock"
          ".git"
        ];
        settings.nil = {
          diagnostics = {
            ignored = [
              "unused_binding"
              "unused_with"
            ];
          };
        };
      };
      nixd = {
        enable = true;
        cmd = [
          "${lib.getExe pkgs.nixd}"
          "--log=error"
        ];
        filetypes = [
          "nix"
        ];
        root_markers = [
          "flake.nix"
          "flake.lock"
          ".git"
        ];
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false;
              lineFoldingOnly = true;
            };
          };
        };
      };

      clangd = {
        cmd = [
          "${pkgs.clang-tools}/bin/clangd"
          "--clang-tidy"
        ];
      };

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
          linters = {
            spellCheck = true;
          };

          diagnosticSeverity = "hint";
          dialect = "American";
        };
      };
    };

    nvim-docs-view = {
      enable = false;
    };
  };
}
