{ nvimSize, inputs, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./c-cpp.nix { inherit nvimSize pkgs lib; })
  (import ./nix.nix { inherit nvimSize inputs pkgs lib; })
  (import ./openscad.nix { inherit nvimSize pkgs lib; })
  (import ./rust.nix {
    inherit nvimSize pkgs lib;
    inherit (inputs) rustowl-flake;
  })
  (import ./zig.nix { inherit nvimSize pkgs lib; })
  (import ./dart.nix { inherit nvimSize pkgs lib; })
  (import ./clojure.nix { inherit nvimSize pkgs lib; })
  (import ./sql.nix { inherit nvimSize pkgs lib; })

  {
    languages = let

      enableExtra = nvimSize <= 300;

    in {
      enableFormat = enableExtra;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = nvimSize <= 400;


      ts = {
        enable = enableExtra;
        extraDiagnostics.enable = true;
      };

      python = {
        enable = true;

        lsp = {
          enable = enableExtra;
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

        extraDiagnostics = {
          enable = true;
        };
      };

      html = {
        enable = true;
        extraDiagnostics = {
          enable = enableExtra;
        };
      };

      css = {
        enable = true;
      };

      go = {
        enable = enableExtra;
      };

      lua = {
        enable = true;

        extraDiagnostics = {
          enable = enableExtra;
          types = [
            "luacheck"
          ];
        };

        lsp = {
          enable = true;
          lazydev = {
            enable = true;
          };
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
        enable = enableExtra;
      };

      yaml = {
        enable = true;

        lsp = {
          enable = enableExtra;
        };
      };

      typst = {
        enable = enableExtra;

        lsp = {
          enable = enableExtra;
        };

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

      clojure = {
        enable = enableExtra;
      };

      helm = {
        enable = enableExtra;
      };

      wgsl = {
        enable = enableExtra;
      };

      just = {
        enable = enableExtra;
      };
    };
  }
]
