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
        (mkSpell "en.utf-8.spl" "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy")
        (mkSpell "he.utf-8.spl" "12q7vw7fiwp7fw708df6bad0dajcfasq5vg0kp2y4vmaiibzv48v")
      ];
    })
  ];

  spellcheck = {
    enable = true;
    languages = [
      "en"
      "he"
    ];
    programmingWordlist = {
      enable = true;
    };
  };

}
