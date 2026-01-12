{ nvimSize, inputs, pkgs, lib }: let

  enableExtra = nvimSize <= 600;

in {

  languages = {
    nix = {
      enable = true;
      lsp = {
        enable = false;
        #server = "nixd";
      };
      extraDiagnostics = {
        enable = true;
        types = [
          "statix"
          "deadnix"
        ];
      };
    };
  };

  lsp = {
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
              #"unused_binding"
              "unused_with"
            ];
          };
          nix = {
            binary = lib.getExe pkgs.lixPackageSets.git.lix;

            maxMemoryMB = 16384;

            flake = {
              autoArchive = true;

              #autoEvalInputs = true;

              nixpkgsInputName = "nixpkgs";
            };
          };
        };

        capabilities = {

        };
      };

      nixd = lib.mkIf enableExtra {
        enable = enableExtra;

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

        settings.nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };

          formatting = {
            command = [
              (lib.getExe pkgs.nixfmt)
            ];
          };

          diagnostic = {
            suppress = [
              "sema-unused-def-let"
            ];
          };

          options = let

            lsp-input = inputs.lsp-inputs + /.;

          in {
            nixos = {
              expr = "(builtins.getFlake \"${lsp-input}\").nixosConfigurations.default.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${lsp-input}\").homeConfigurations.default.options";
            };
            home-manager-module = {
              expr = "(builtins.getFlake \"${lsp-input}\").nixosConfigurations.home-manager.options.home-manager.users.type.getSubOptions []";
            };
            flake-parts = {
              expr = "(builtins.getFlake \"${lsp-input}\").debug.options";
            };
            flake-parts-per-system = {
              expr = "(builtins.getFlake \"${lsp-input}\").currentSystem.options";
            };
          };
        };

        /*capabilities = {
          textDocument = {
            hover = false;
            signatureHelp = false;
            documentSymbol = false;

            foldingRange = {
              dynamicRegistration = false;
              lineFoldingOnly = true;
            };
          };
        };*/
      };
    };
  };
}
