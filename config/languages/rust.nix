{ nvimSize, pkgs, lib }: let

  enable = nvimSize <= 800;

in {
  extraPackages = lib.optionals enable [
    pkgs.cargo
    pkgs.rustc
    pkgs.clippy
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
}
