{ nvimSize, pkgs }: let

  enableExtra = nvimSize < 200;

in {
  lsp = {
    presets = {
      markdown-oxide.enable = true;
    };

    servers = {
      markdown-oxide = {
        filetypes = [
          "markdown"
        ];
        capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true;
      };
    };
  };

  languages = {
    markdown = {
      enable = true;

      extensions = {
        render-markdown-nvim = {
          #enable = true;
        };
        markview-nvim = {
          enable = true;

          setupOpts = {
            markdown = {
              #enable = false;
            };

            preview = {
              ignore_buftypes = [
                "nofile"
                "prompt"
              ];
            };

            experimental = {
              fancy_comments = true;
              prefer_nvim = true;
              file_open_command = "tabnew";
            };
          };
        };
      };

      extraDiagnostics = {
        enable = enableExtra;
      };

      lsp = {
        enable = enableExtra;
      };
    };
  };
}
