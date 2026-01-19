{ enableExtra, pkgs, lib }: {
  extraPackages = lib.optionals enableExtra [
    pkgs.py-spy
  ];

  languages = {
    python = {
      enable = true;

      lsp = {
        enable = enableExtra;
      };
    };
  };

  lsp = {
    servers = {
      # Ruff python linter/LSP
      ruff = lib.mkIf enableExtra {
        cmd = [
          "${lib.getExe pkgs.ruff}"
          "server"
        ];

        filetypes = [
          "python"
        ];
      };

      ty = {
        enable = true;
        cmd = [
          (lib.getExe pkgs.ty)
          "server"
        ];
        filetypes = [
          "python"
        ];
        root_markers = [
          "pyproject.toml"
          "setup.py"
          "setup.cfg"
          "requirements.txt"
          "Pipfile"
          ".git"
        ];
      };
    };
  };
}
