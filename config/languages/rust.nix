{ nvimSize, npins, rustowl-flake, pkgs, lib }: let

  enable = nvimSize <= 800;

  inherit (pkgs.vimUtils) buildVimPlugin;

  rustowl = rustowl-flake.packages.${pkgs.stdenv.hostPlatform.system};

in {
  extraPackages = lib.optionals enable [
    (if pkgs.stdenv.hostPlatform.isAarch64
      then pkgs.cargo
      else (pkgs.rust-bin.fromRustupToolchain {
        channel = "nightly";

        components = [
          "rustc"
          "cargo"
          "rustfmt"
          "rust-std"
          "rust-docs"
          "rust-analyzer"
          "clippy"
          "miri"
          "rust-src"
          "llvm-tools"
        ];

        targets = [
          "aarch64-unknown-linux-gnu"
          "x86_64-unknown-linux-gnu"

          "aarch64-unknown-linux-musl"
          "x86_64-unknown-linux-musl"

          #"aarch64-unknown-illumos"
          #"x86_64-unknown-illumos"

          "aarch64-unknown-none"
          "x86_64-unknown-none"

          # Web
          "wasm32-unknown-unknown"

          # Embedded microcontrollers
          "thumbv6m-none-eabi"
          "thumbv7em-none-eabihf"
          "thumbv8m.main-none-eabihf"
          "riscv32imc-unknown-none-elf"
          "riscv32imac-unknown-none-elf"

          # ESP32
          #"riscv32imc-esp-espidf"
          #"riscv32imac-esp-espidf"
          #"riscv32imafc-esp-espidf"
          #"xtensa-esp32s3-espidf"
          #"xtensa-esp32s3-none-elf"
        ];
      })
    )

    pkgs.cargo-deny
    pkgs.cargo-bloat
    pkgs.cargo-generate

    pkgs.cargo-flamegraph

    pkgs.cargo-tarpaulin
    pkgs.cargo-llvm-cov

    rustowl.rustowl
  ];

  globals = {
    # Disable default textwidth and indent styles
    rust_recommended_style = 0;

    # Conceal doesn't seem to work
    #rust_conceal = 1;
    #rust_conceal_pub = 1;
    #rust_conceal_mod_path = 1;
  };

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
            check = {
              command = "clippy",
            },

            diagnostics = {
              experimental = {
                enable = true,
              },

              styleLints = {
                enable = true,
              },
            },

            cargo = {
              allFeature = true,
            },

            checkOnSave = true,

            procMacro = {
              enable = true,
            },

            -- FIXME: rust-analyzer watches >70K files???
            files = {
              exclude = {
                ".direnv"
              },
            },

            --rustfmt = {
            --  overrideCommand = {
            --    ' ''${pkgs.rustfmt}'
            --  },
            --},
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
