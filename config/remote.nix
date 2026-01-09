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

      "sshfs.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "sshfs.nvim";
          version = "0";

          src = npins."sshfs.nvim";
        };

        setupModule = "sshfs";
        setupOpts = {
          connections = {
            ssh_configs = [                 # Table of ssh config file locations to use
              "~/.ssh/config"
              "~/.ssh/impure/config"
              "/etc/ssh/ssh_config"
            ];
              # SSHFS mount options (table of key-value pairs converted to sshfs -o arguments)
              # Boolean flags: set to true to include, false/nil to omit
              # String/number values: converted to key=value format
            sshfs_options = {
              reconnect = true;             #-- Auto-reconnect on connection loss
              ConnectTimeout = 5;           #-- Connection timeout in seconds
              compression = "yes";          ## Enable compression
              ServerAliveInterval = 15;     # Keep-alive interval (15s × 3 = 45s timeout)
              ServerAliveCountMax = 3;      # Keep-alive message count
              dir_cache = "yes";            # Enable directory caching
              dcache_timeout = 300;         # Cache timeout in seconds
              dcache_max_size = 10000;      # Max cache size
              #allow_other = true;        # Allow other users to access mount
              #uid = "1000,gid=1000";     # Set file ownership (use string for complex values)
              #follow_symlinks = true;    # Follow symbolic links
            };
            control_persist = "10m";       # How long to keep ControlMaster connection alive after last use
            socket_dir = lib.generators.mkLuaInline /* lua */ ''vim.fn.expand("$HOME/.ssh/sockets")''; # Directory for ControlMaster sockets
          };

          mounts = {
            base_dir = lib.generators.mkLuaInline /* lua */ ''vim.fn.expand("$HOME") .. "/.sshfs"''; # where remote mounts are created
          };

          hooks = {
            on_exit = {
              auto_unmount = true;
              clean_mount_folders = true;
            };

            on_mount = {
              auto_change_to_dir = true;
              auto_run = "none";
            };
          };

          ui = {
            file_picker = {
              preferred_picker = "snacks";

              fallback_to_netrw = true;
              netrw_command = "Texplore";
            };
            remote_picker = {
              preferred_picker = "auto";
            };
          };

          lead_prefix = "<leader>rr";

          global_paths = [
            "/etc/nixos"
            "/var/lib"
            "/var/log"
          ];
        };

        lazy = true;

        cmd = [
          "SSHConnect"
            "SSHDisconnect"
            "SSHDisconnectAll"
            "SSHConfig"
            "SSHReload"
            "SSHFiles"
            "SSHGrep"
            "SSHLiveFind"
            "SSHLiveGrep"
            "SSHExplore"
            "SSHChangeDir"
            "SSHCommand"
            "SSHTerminal"
        ];
      };

      # TODO: Add automatic nix copy of ripgrep
      "remote-sshfs.nvim" = lib.mkIf false {
        package = pkgs.vimPlugins.remote-sshfs-nvim;

        setupModule = "remote-sshfs";
        setupOpts = {
          connections = {
            ssh_configs = [
              (lib.generators.mkLuaInline /* lua */ ''vim.fn.expand "$HOME" .. "/.ssh/impure/config"'')

              (lib.generators.mkLuaInline /* lua */ ''vim.fn.expand "$HOME" .. "/.ssh/config"'')
              ''/etc/ssh/ssh_config''
            ];

            ssh_known_hosts = lib.generators.mkLuaInline /* lua */ ''vim.fn.expand "$HOME" .. "/.ssh/known_hosts"'';
          };

            #find_command = "/nix/store/0qh46n4bqwci1dli1bjqkavvzmdw87x3-ripgrep-15.1.0/bin/rg";
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
