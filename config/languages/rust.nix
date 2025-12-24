{ nvimSize, rustowl-flake, pkgs, lib }: let

  enable = nvimSize <= 800;

  inherit (pkgs.vimUtils) buildVimPlugin;

  rustowl = rustowl-flake.packages.${pkgs.stdenv.hostPlatform.system};

in {
  extraPackages = lib.optionals enable [
    pkgs.cargo
    pkgs.rustc
    pkgs.clippy

    pkgs.cargo-deny
    pkgs.cargo-bloat
    pkgs.cargo-generate

    rustowl.rustowl
  ];

  languages = {
    rust = {
      inherit enable;
      lsp = {
        enable = true;

        opts = /* lua */ ''
          ['rust-analyzer'] = {
            cargo = {
              allFeature = true
            },
            checkOnSave = true,
            procMacro = {
              enable = true,
            },
          },
        '';
      };

      extensions = {
        crates-nvim = {
          enable = true;

          setupOpts = {
            completion = {
              crates = {
                enabled = true;

                max_results = 10;
                min_chars = 5;
              };
            };

            lsp = {
              enabled = true;

              actions = true;
              completion = true;
              hover = true;
            };
          };
        };
      };

      format = {
        enable = true;
        type = [
          "rustfmt"
        ];
      };
    };
  };

  lazy = {
    plugins = {
      rustowl = lib.mkIf enable {
        package = rustowl.rustowl-nvim;

        lazy = true;

        cmd = [
          "Rustowl"
        ];

        #ft = [
        #  "rust"
        #];
      };

      # For memory layout
      ferris = lib.mkIf enable {
        package = buildVimPlugin {
          pname = "ferris";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "vxpm";
            repo = "ferris.nvim";
            rev = "275865530d753a205740804f1ce163af2322db57";
            hash = "sha256-6wQi4yurKTSPxYDxKnQJlVMLI41RB9Kj8htlRNeiF0I=";
          };
        };

        setupModule = "ferris";

        setupOpts = {
          create_commands = true;

          url_handler = "xdg-open";
        };

        lazy = true;

        ft = [
          "rust"
        ];
      };
    };
  };
  }
