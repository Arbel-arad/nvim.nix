{ npins, pkgs, lib }: {
  lazy = {
    plugins = let

      neovim-session-manager = pkgs.vimUtils.buildVimPlugin {
        pname = "neovim-session-manager";
        version = "0";

        src = npins."neovim-session-manager";

        dependencies = [
          pkgs.vimPlugins.plenary-nvim
        ];
      };

      neovim-project = pkgs.vimUtils.buildVimPlugin {
        pname = "neovim-project";
        version = "0";

        src = npins."neovim-project";

        dependencies = [
          pkgs.vimPlugins.plenary-nvim
          neovim-session-manager

          # Optional pickers
          pkgs.vimPlugins.telescope-nvim
          pkgs.vimPlugins.fzf-lua
          pkgs.vimPlugins.snacks-nvim
        ];
      };

    in {
      neovim-project = {
        package = neovim-project;

        beforeSetup = /* lua */ ''
          -- enable saving the state of plugins in the session
          vim.opt.sessionoptions:append("globals")
        '';

        setupModule = "neovim-project";
        setupOpts = {
          projects = [
            "~/Projects/*"
          ];

          last_session_on_startup = false;

          dashboard_mode = true;

          per_branch_sessions = true;

          picker = {
            type = "telescope";

            preview = {
              enabled = true;
              git_status = true;
              gut_fetch = false;
              show_hidden = true;
            };
          };
        };

        lazy = false;
        priority = 100;
      };
    };
  };
}
