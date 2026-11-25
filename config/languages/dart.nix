{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 200;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.flutter
    pkgs.dart
  ];

  languages = {
    dart = {
      enable = enableExtra;

      dap = {
        enable = true;
      };

      lsp = {
        enable = false;
      };

      extensions = {
        flutter-tools = {
          enable = enableExtra;
        };
      };
    };
  };
}
