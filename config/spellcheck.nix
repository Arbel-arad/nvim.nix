{ pkgs }: let

  source = "https://ftp.nluug.nl/pub/vim/runtime/spell/";
  mkSpell = file: hash: {
    name = "spell/${file}";
    path = builtins.fetchurl {
      url = "${source + file}";
      sha256 = hash;
    };
  };

in {

  additionalRuntimePaths = [
    (builtins.path {
      name = "spell-files";
      path = pkgs.linkFarm "spell" [
        (mkSpell "he.utf-8.spl" "12q7vw7fiwp7fw708df6bad0dajcfasq5vg0kp2y4vmaiibzv48v")
      ];
    })
  ];
}
