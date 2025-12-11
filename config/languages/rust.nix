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

      crates = {
        enable = true;
        codeActions = true;
      };

      format = {
        enable = true;
        type = "rustfmt";
      };
    };
  };
}
