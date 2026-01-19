{ npins, pkgs }: let


in {
  lazy = {
    plugins = {
      "exrc.nvim" = {
        #enabled = false;

        package = pkgs.vimUtils.buildVimPlugin {
          pname = "exrc.nvim";
          version = "0";

          src = npins."exrc.nvim";
        };

        setupModule = "exrc";
        setupOpts = {
          exrc_name = ".nvim.lua";
          on_vim_enter = false;
          on_dir_changed = {
            enabled = true;
            use_ui_select = true;
          };
          trust_on_write = false;
          use_telescope = true;
          lsp = {
            auto_setup = false;
          };
          commands = {
            instant_edit_single = true;
          };
        };

        lazy = false;
      };
    };
  };
}
