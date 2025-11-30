{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 200;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.flutter
    pkgs.dart
  ];
}
