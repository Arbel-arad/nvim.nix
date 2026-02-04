{ nvimSize, inputs, npins, pkgs, lib, lib' }: lib'.mergeAttrsList [
  (import ./c-cpp.nix { inherit nvimSize npins pkgs lib; })
  (import ./nix.nix { inherit nvimSize inputs pkgs lib; })
  (import ./openscad.nix { inherit nvimSize pkgs lib; })
  (import ./rust.nix {
    inherit nvimSize npins pkgs lib;
    inherit (inputs) rustowl-flake;
  })
  (import ./zig.nix { inherit nvimSize pkgs lib; })
  (import ./dart.nix { inherit nvimSize pkgs lib; })
  (import ./clojure.nix { inherit nvimSize pkgs lib; })
  (import ./sql.nix { inherit nvimSize npins pkgs lib; })
  (import ./python.nix {
    inherit pkgs lib;
    enableExtra = nvimSize <= 300;
  })

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

      odin = {
        enable = enableExtra;
      };

      markdown = {
        enable = true;

        extensions = {
          render-markdown-nvim = {
            #enable = true;
          };
          markview-nvim = {
            enable = true;

            setupOpts = {
              markdown = {
                #enable = false;
              };

              preview = {
                ignore_buftypes = [
                  "nofile"
                  "prompt"
                ];
              };

              experimental = {
                fancy_comments = true;
                prefer_nvim = true;
                file_open_command = "tabnew";
              };
            };
          };
        };

        extraDiagnostics = {
          enable = enableExtra;
        };

        lsp = {
          enable = enableExtra;
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
          enable = enableExtra;
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

        lsp = {
          enable = enableExtra;
        };
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
