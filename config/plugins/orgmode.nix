{ nvimSize, npins, nvf, pkgs, lib }: let

  enabled = nvimSize <= 400;

  inherit (nvf.lib.nvim) lua dag;

  org_priority = 100;

  config = {
    orgmode = {

    };

    org-roam = {
      directory = "~/.org-roam";
    };
  };

in {
  startPlugins = with pkgs.vimPlugins; [
    orgmode
    #org-roam-nvim
  ];

  pluginRC = {
    orgmode = dag.entryAnywhere /* lua */ ''
        require("orgmode").setup(${lua.toLuaObject config.orgmode})
        --[[
          require("org-roam").setup(${lua.toLuaObject config.org-roam})
        ]]
    '';
  };

  lazy = {
    plugins = {
      orgmode = lib.mkIf false {
        #inherit enabled;
        enabled = false;

        priority = org_priority + 10;

        package = pkgs.vimPlugins.orgmode;

        setupModule = "orgmode";

        setupOpts = {
          org_startup_folded = "inherit";
          org_agenda_files = "~/orgfiles/**/*";
          org_default_notes_file = "~/orgfiles/refile.org";

          ui = {
            input = {
              use_vim_ui = true;
            };
          };
        };

        lazy = false;

        ft = [
          "org"
        ];

        cmd = [
          "Org"
        ];

        event = [
          # "BufEnter"
        ];
      };

      "org-roam.nvim" = lib.mkIf true {
        #inherit enabled;
        #enabled = false;

        priority = org_priority + 5;

        package = pkgs.vimPlugins.org-roam-nvim;

        setupModule = "org-roam";

        setupOpts = {
          directory = "~/.org-roam";
          #org_files = [

          #];
        };

        lazy = true;

        ft = [
          "org"
        ];

        cmd = [
          "Org"
          "RoamReset"
        ];

        event = [
          #"BufEnter"
        ];


        /* NOTE:
        *   If there are nodes missing from the roam search, rebuild database with
        *   `:RoamReset sync`
        */
      };

      org-bullets = lib.mkIf enabled {
        inherit enabled;
        #enabled = false;

        priority = org_priority + 1;

        package = pkgs.vimUtils.buildVimPlugin {
          pname = "org-bullets";
          version = "0";

          src = npins."org-bullets.nvim";
        };

        setupModule = "org-bullets";

        setupOpts = {

        };

        lazy = true;

        ft = [
          "org"
        ];

        cmd = [
          "Org"
        ];

        event = [
          "BufEnter"
        ];
      };
    };
  };

  treesitter = {
    grammars = [
      pkgs.luajitPackages.tree-sitter-orgmode
    ];
  };
}
