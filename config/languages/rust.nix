{ nvimSize, npins, rustowl-flake, pkgs, lib }: let

  enable = nvimSize <= 800;

  inherit (pkgs.vimUtils) buildVimPlugin;

  rustowl = rustowl-flake.packages.${pkgs.stdenv.hostPlatform.system};

in {
  extraPackages = lib.optionals enable [
    pkgs.cargo
    pkgs.rustc
    pkgs.clippy
    pkgs.rust-analyzer

    pkgs.cargo-deny
    pkgs.cargo-bloat
    pkgs.cargo-generate

    pkgs.cargo-flamegraph

    rustowl.rustowl
  ];

  languages = {
    rust = {
      inherit enable;

      lsp = {
        enable = true;

        # Use rust-analyzer from `$PATH` for compatibility with nvim-unwrapped and project-specific arches
        package = [
          "rust-analyzer"
        ];

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

          src = npins."ferris.nvim";
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
