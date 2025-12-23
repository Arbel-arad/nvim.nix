{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 300;

in {
  extraPackages = lib.optionals enabled [
    pkgs.leiningen
    pkgs.clojure
  ];

  languages = {
    clojure = {
      enable = enabled;
    };
  };
}
