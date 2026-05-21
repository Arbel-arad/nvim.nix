{ pkgs, lib }: let

  mkLinkSetTOML = path: list: builtins.concatStringsSep "\n" (
    lib.forEach list (item: /* bash */ ''
      ln -s ${pkgs.writers.writeTOML item.name item.content} "${path}/${item.name}.toml"
    '')
  );

  configs = mkLinkSetTOML "$out/config" [
    {
      name = "config";
      content = {

      };
    }
    {
      name = "cable/tldr";
      content = {
        metadata = {
          name = "tldr";
          description = "Browse and preview TLDR help pages for command-line tools";
          requirements = [ "tldr" ];
        };

        source = {
          command = "tldr --list";
        };

        preview = {
          command = "tldr '{0}' --color always";
        };

        ui = {
          layout = "portrait";
        };

        keybindings = {
          ctrl-e = "actions:open";
        };

        actions = {
          open = {
            description = "Open the selected TLDR page";
            command = "tldr '{0}'";
            mode = "execute";
          };
        };
      };
    }
  ];

  tv-wrapped = pkgs.symlinkJoin {
    name = "tv-wrapped";

    paths = [
      pkgs.television
      ./tv
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = /* bash */ ''
      mkdir -p "$out/config/cable"

      ${configs}

      wrapProgram "$out/bin/tv" \
        --set TELEVISION_CONFIG "$out/config"

    '';
  };

in {
  extraPackages = [
    tv-wrapped

    # For TLDR
    pkgs.tealdeer
  ];

  lazy.plugins."tv.nvim" = {
    package = pkgs.vimPlugins.tv-nvim;

    setupModule = "tv";
    setupOpts = {

    };

    lazy = true;
    cmd = [
      "Tv"
    ];
  };
}
