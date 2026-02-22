{ nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 300;

in {
  extraPackages = lib.optionals enabled [
    pkgs.leiningen
    pkgs.clojure

    pkgs.clojure-lsp
  ];

  languages = {
    clojure = {
      enable = enabled;
    };
  };
}
