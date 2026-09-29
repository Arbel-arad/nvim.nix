{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 500;

in {
  languages = {
    html = {
      enable = true;

      lsp = {
        enable = enableExtra;
      };
      extraDiagnostics = {
        enable = enableExtra;
      };
    };

    css = {
      enable = true;

      lsp = {
        enable = enableExtra;
      };
    };

    scss = {
      enable = enableExtra;
    };

    typescript = {
      enable = enableExtra;
      extraDiagnostics.enable = true;
    };

    tsx = {
      enable = enableExtra;
    };
  };

  lsp.presets.tailwindcss-language-server.enable = true;

  formatter.conform-nvim.presets.prettier = {
    enable = true;

    plugins = [
      #pkgs.prettier-plugin-tailwindcss
    ];
  };
}
