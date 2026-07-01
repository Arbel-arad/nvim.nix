{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 300;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.typst
  ];

  languages = {
    typst = {
      enable = enableExtra;

      lsp = {
        enable = enableExtra;
      };

      extensions = {
        typst-concealer = {
          enable = true;
          mappings = {

          };
        };
        typst-preview-nvim = {
          enable = true;
        };
      };
    };
  };
}
