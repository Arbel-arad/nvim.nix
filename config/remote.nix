{ nvimSize, npins, pkgs, lib }: let

  enableExtra = nvimSize <= 0;

  distant-src = npins.distant;

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

    pkgs.sshfs
  ];

  globals = {
    remote_sshfs_status_icon = "󱘖 ";
  };

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

      # TODO: Add automatic nix copy of ripgrep
      "remote-sshfs.nvim" = {
        package = pkgs.vimPlugins.remote-sshfs-nvim;

        setupModule = "remote-sshfs";
        setupOpts = {

        };

        after = /* lua */ ''
          require('telescope').load_extension 'remote-sshfs'
        '';

        lazy = true;

        cmd = [
          "RemoteSSHFSConnect"
          "RemoteSSHFSDisconnect"
          "RemoteSSHFSEdit"
          "RemoteSSHFSFindFiles"
          "RemoteSSHFSLiveGrep"
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

        # Distant manager needs to be started before connections
        # distant manager listen --user --access 0o600
        # After that, connections can be initiated with :DistantConnect ssh://<user>@<target>
        before = /* lua */ ''

        '';

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
          #"..."
        ];
      };
    };
  };
}
