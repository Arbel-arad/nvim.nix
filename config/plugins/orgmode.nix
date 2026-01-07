{ nvimSize, npins, nvf, pkgs, lib }: let

  enabled = nvimSize <= 400;

  inherit (nvf.lib.nvim) dag;

  org_priority = 100;

in {
  lazy = {
    plugins = {
      orgmode = {
        inherit enabled;

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

      "org-roam.nvim" = {
        inherit enabled;
        #enabled = false;

        priority = org_priority + 5;

        package = pkgs.vimPlugins.org-roam-nvim;

        setupModule = "org-roam";

        setupOpts = {
          directory = "~/.org-roam";
          org_files = [

          ];
        };

        lazy = false;

        ft = [
          "org"
        ];

        cmd = [
          "Org"
        ];

        event = [
          "BufEnter"
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
