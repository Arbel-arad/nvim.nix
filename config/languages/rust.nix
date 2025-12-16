{ nvimSize, pkgs, lib }: let

  enable = nvimSize <= 800;

  inherit (pkgs.vimUtils) buildVimPlugin;

  rustowl-src = pkgs.fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    rev = "655bc5c37e59156954fa9af3e6466602e7dfa814";
    hash = "sha256-vvTXzlBgJKM0VOkFL071y0Yu4NqTCk2lYMmku0savx4=";
  };

  # Requires nightly rust to build properly
  rustowl = pkgs.rustPlatform.buildRustPackage {
    name = "rustowl";

    src = rustowl-src;

    cargoLock = {
      lockFile = rustowl-src + /Cargo.lock;
    };
  };

in {
  extraPackages = lib.optionals enable [
    pkgs.cargo
    pkgs.rustc
    pkgs.clippy

    #rustowl
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
        package = buildVimPlugin {
          pname = "rustowl";
          version = "0";

          src = rustowl-src;
        };

        lazy = false;

        ft = [
          "rust"
        ];
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
