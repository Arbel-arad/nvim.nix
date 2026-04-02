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

      flutter-tools = {
        enable = enableExtra;
        color = {
          enable = true;
          highlightBackground = false;
          highlightForeground = false;
          virtualText = {
            enable = true;
            character = ''"■"'';
          };
        };
      };
    };
  };
}
