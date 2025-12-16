{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 600;

in {
  extraPackages = lib.optionals enabled [
    pkgs.zig
  ];

  languages = {
    zig = lib.mkIf enabled {
      enable = true;

      lsp = {
        # Configured manually
        enable = false;
      };
    };
  };

  lsp = {
    servers = {
      zls = lib.mkIf enabled {
        root_markers = [
          ".git"
          "build.zig"
          "build.zig.zon"
        ];

        cmd = [
          "${lib.getExe pkgs.zls}"
          "--config-path"
          "${(pkgs.formats.json { }).generate "zls.json" {
            warn_style = true;
            #enable_build_on_save = true;
            build_on_save_args = [
              #"install"
              #  "-fno-emit-bin"
            ];
          }}"
        ];

        filetypes = [
          "zig"
          "zon"
        ];

        settings = {
          zls = {
            enable_build_on_save = true;
          };
        };
      };
    };
  };

  diagnostics = {
    nvim-lint = {
      linters = {
        zlint = lib.mkIf enabled {
          cmd = "${lib.getExe pkgs.zig-zlint}";
        };
      };

      linters_by_ft = {
        zig = [
          "zlint"
        ];
      };
    };
  };
}
