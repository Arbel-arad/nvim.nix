{ pkgs, lib }: {
  lazy = {
    plugins = let

      neovim-session-manager = pkgs.vimUtils.buildVimPlugin {
        pname = "neovim-session-manager";
        version = "0";

        src = pkgs.fetchFromGitHub {
          owner = "Shatur";
          repo = "neovim-session-manager";
          rev = "3409dc920d40bec4c901c0a122a80bee03d6d1e1";
          hash = "sha256-k2akj/s6qJx/sCnz3UNHo5zbENTpw+OPuo2WPF1W7rg=";
        };

        dependencies = [
          pkgs.vimPlugins.plenary-nvim
        ];
      };

      neovim-project = pkgs.vimUtils.buildVimPlugin {
        pname = "neovim-project";
        version = "0";

        src = pkgs.fetchFromGitHub {
          owner = "coffebar";
          repo = "neovim-project";
          rev = "cfe4ffe8deb89a72b0a46b8f22183a3b534d9f00";
          hash = "sha256-dizWD29IKPEy8AtXBqkhaZpDTas033jlfKKagAUSZqo=";
        };

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
