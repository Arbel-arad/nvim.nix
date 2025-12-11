{ nvimSize, inputs, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./c-cpp.nix { inherit nvimSize pkgs lib; })
  (import ./nix.nix { inherit inputs pkgs lib; })
  (import ./openscad.nix { inherit pkgs lib; })
  (import ./rust.nix { inherit nvimSize pkgs lib; })
  (import ./zig.nix { inherit pkgs lib; })
  (import ./dart.nix { inherit nvimSize pkgs lib; })

  {
    languages = let

      enableExtra = nvimSize <= 300;

    in {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = nvimSize <= 300;


      ts = {
        enable = enableExtra;
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

      odin = {
        enable = enableExtra;
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
        extraDiagnostics = {
          enable = true;
        };
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
          enable = true;
        };
      };

      terraform = {
        enable = true;
      };

      sql = {
        enable = true;
        format = {
          enable = true;
        };
        extraDiagnostics = {
          enable = true;
        };
        lsp = {
          enable = true;
        };
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
        enable = enableExtra;
        dap = {
          enable = true;
        };
        lsp = {
          enable = false;
        };

        flutter-tools = {
          enable = enableExtra;
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

      r = {
        enable = enableExtra;
        lsp = {
          enable = true;
        };
      };

      scala = {
        enable = enableExtra;
        fixShortmess = false;
      };

      elixir = {
        enable = enableExtra;
        elixir-tools = {
          enable = true;
        };
        lsp = {
          enable = true;
        };
      };

      julia = {
        enable = enableExtra;
        lsp = {
          enable = true;
        };
      };

      helm = {
        enable = true;
      };

      wgsl = {
        enable = true;
      };
    };
  }
]
