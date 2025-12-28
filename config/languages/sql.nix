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
          local cwd = vim.fn.getcwd()
          local config_file = io.open(".sqls.yml", r)

          if config_file ~= nil then
            io.close(config_file)
            vim.notify("Starting sqls for "..cwd.."/.sqls.yml")

            vim.lsp.config('sqls', {
                -- your custom client configuration
              cmd = {"${lib.getExe pkgs.sqls}", "-config", cwd.."/.sqls.yml"};
            })
          else
            vim.notify("Starting sqls for global config")

            vim.lsp.config('sqls', {
                -- your custom client configuration
              cmd = {"${lib.getExe pkgs.sqls}"};
            })
          end

          vim.lsp.enable('sqls')
        '';

        lazy = true;

        ft = [
          "sql"
        ];

        cmd = [
          "SqlsExecuteQuery"
          "SqlsExecuteQueryVertical"
          "SqlsShowDatabases"
          "SqlsShowSchemas"
          "SqlsShowConnections"
          "SqlsSwitchDatabase"
          "SqlsSwitchConnection"
        ];
      };
    };
  };
}
