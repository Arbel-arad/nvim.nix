{ pkgs, lib }:{
  lazy = {
    plugins = {
      orgmode = {
        package = pkgs.vimPlugins.orgmode;
        setupModule = "orgmode";

        setupOpts = {
          org_startup_folded = "inherit";
          org_agenda_files = "~/orgfiles/**/*";
          org_default_notes_file = "~/orgfiles/refile.org";
        };

        lazy = true;
        ft = [
          "org"
        ];

        cmd = [
          "Org"
        ];

        event = [
          #"VeryLazy"
        ];
      };
      org-bullets = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "org-bullets";
          version = "0";
          src = pkgs.fetchFromGitHub {
            owner = "nvim-orgmode";
            repo = "org-bullets.nvim";
            rev = "21437cfa99c70f2c18977bffd423f912a7b832ea";
            hash = "sha256-/l8IfvVSPK7pt3Or39+uenryTM5aBvyJZX5trKNh0X0=";
          };
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
