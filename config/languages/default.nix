{ nvimSize, ... }:{
  languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;
    enableDAP = true;

    rust = {
      enable = true;
      lsp = {
        enable = true;
        opts = /* lua */ ''
          ['rust-analyzer'] = {
          cargo = {allFeature = true},
          checkOnSave = true,
            procMacro = {
              enable = true,
            },
          },
        '';
      };
      crates = {
        enable = true;
        codeActions = true;
      };
    };
    nix = {
      enable = true;
      lsp = {
        server = "nixd";
      };
      extraDiagnostics = {
        enable = true;
        types = [
          "statix"
          "deadnix"
        ];
      };
    };
    clang = {
      enable = true;
      dap = {
        enable = true;
      };
    };
    ts = {
      enable = true;
      extraDiagnostics.enable = true;
    };
    python = {
      enable = true;
    };
    zig = {
      enable = true;
      lsp = {
        # Configured manually
        enable = false;
      };
    };
    markdown = {
      enable = true;
      extensions = {
        render-markdown-nvim = {
            enable = true;
        };
      };
      extraDiagnostics.enable = true;
    };
    html = {
      enable = true;
    };
    css = {
      enable = true;
    };
    go = {
      enable = true;
    };
    lua = {
      enable = true;
    };
    bash = {
      enable = true;
      extraDiagnostics = {
        enable = true;
        types = [
          "shellcheck"
        ];
      };
    };
    nu = {
      enable = true;
    };
    assembly = {
      enable = true;
    };
    haskell = {
      enable = nvimSize <= 0;
      dap = {
        # Package haskell-debug-adapter is currently broken
        enable = false;
      };
    };
    terraform = {
      enable = true;
    };
    sql = {
      enable = true;
      extraDiagnostics.enable = true;
    };
    yaml = {
      enable = true;
    };
    typst = {
      enable = true;
      extensions = {
        typst-concealer = {
          enable = true;
          mappings = {

          };
        };
        typst-preview-nvim = {
          enable = true;
        };
      };
    };
    dart = {
      enable = true;
      dap = {
        enable = true;
      };
      lsp = {
        enable = false;
      };

      flutter-tools = {
        enable = true;
        color = {
          enable = true;
          highlightBackground = false;
          highlightForeground = false;
          virtualText = {
            enable = true;
            character = ''"■"'';
          };
        };
      };
    };
    scala = {
      enable = true;
      fixShortmess = false;
    };
  };
}
