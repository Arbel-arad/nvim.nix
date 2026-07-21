{ enableExtra, pkgs, lib }: {
  extraPackages = lib.optionals enableExtra (
    [
      pkgs.black
      # FIXME: broken on aarch64
    ] ++ lib.optionals (!pkgs.stdenv.hostPlatform.isAarch64) [
      (pkgs.py-spy.overrideAttrs (final: prev: {
        checkFlags = (prev.checkFlags or []) ++ [
          #FIXME: pyspy tests
          "--skip=test_thread_names"
        ];
      }))
    ]
  );

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

      ty = lib.mkIf enableExtra {
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
