{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 0;

  distant-src = pkgs.fetchFromGitHub {
    owner = "arbel-arad";
    repo = "distant";
    rev = "bd7d331ae457ed7954ec9c6e5c0202408612a2fa";
    hash = "sha256-yq/ZuCBZ5iaF9UfzPpi20ufCOeqz+PeU/NGy4o8/aC8=";
  };

  distant = pkgs.rustPlatform.buildRustPackage {
    name = "distant";

    src = distant-src;

    cargoLock = {
      lockFile = distant-src + /Cargo.lock;
    };

    nativeBuildInputs = [
      pkgs.perl
    ];

    doCheck = false;

    meta = {
      mainProgram = "distant";
    };
  };

in {
  extraPackages = lib.optionals enableExtra [
    distant
  ];

  lazy = {
    plugins = {
      "remote-nvim.nvim" = {
        enabled = false;
        package = pkgs.vimPlugins.remote-nvim-nvim;

        setupOpts = {

        };

        lazy = true;
        event = [
          "BufEnter"
        ];
      };

      "distant.nvim" = {
        enabled = enableExtra;
          # Needs updates
          # https://github.com/myclevorname/distant
        package = pkgs.vimPlugins.distant-nvim;

        #setupModule = "distant";
        #setupOpts = {
        #  client = {
        #    bin = if enableExtra then "${lib.getExe pkgs.distant}" else "";
        #  };
        #};

        after = if enableExtra then /* lua */ ''
          local plugin = require('distant')
          plugin:setup({
            client = {
              bin = '${lib.getExe distant}'
            }
          })
        '' else "";

        lazy = true;
        cmd = [
          "Distant"
          "DistantOpen"
          "DistantConnect"
          "DistantLaunch"
          "DistantInstall"
        ];
      };
    };
  };
}
