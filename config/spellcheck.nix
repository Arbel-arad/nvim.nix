{ nvimSize, nvf, pkgs, lib }: let

  enableExtra = nvimSize <= 100;

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
    ./plugins/spell-lists

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
    ] ++ lib.optionals enableExtra [
      "he"
    ];

    programmingWordlist = {
      enable = true;
    };
  };

  autocmds = [
    {
      event = [
        "TermOpen"
      ];
      pattern = null;
      command = "setlocal nospell";
      desc = "Disable spellcheck for terminal buffers";
    }
  ];

  # Append location of the programming word list
  #luaConfigRC = {
  #  programming-word-location = nvf.lib.nvim.dag.entryAfter [ "vim-dirtytalk" ] /* lua */ ''
  #    vim.opt.rtp:append(vim.fn.stdpath 'data' .. '/site')
  #  '';
  #};
}
