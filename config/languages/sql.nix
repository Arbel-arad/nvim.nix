{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 500;

in {
  languages = {
    sql = {
      enable = true;

      format = {
        enable = enabled;
      };

      extraDiagnostics = {
        enable = enabled;
      };

      lsp = {
        enable = false;
      };
    };
  };

  lazy = {
    plugins = {
      "sqls-nvim" = lib.mkIf enabled {
        inherit enabled;

        package = pkgs.vimUtils.buildVimPlugin {
          pname = "sqls-nvim";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "nanotee";
            repo = "sqls.nvim";
            rev = "bfb7b4090268f6163c408577070da4cc9d7450fd";
            hash = "sha256-PLt4SjPBgTtxAghwffsNICQ0b5AQRrdCrZ7tEHccXIc=";
          };
        };

        after = /* lua */ ''
          vim.lsp.config('sqls', {
              -- your custom client configuration
            cmd = {"${lib.getExe pkgs.sqls}"};
          })
          vim.lsp.enable('sqls')
        '';
      };
    };
  };
}
