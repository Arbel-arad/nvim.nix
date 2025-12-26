{ pkgs }: (
  pkgs.yazi.override {
    settings = {
      yazi = {
        plugin = {
          prepend_previewers = [
            { name = "*justfile"; run = "yazi-plugin-bat"; }
          ];
        };

        manager = {
          sort_by = "natural";
          sort_dir_first = true;
          sort_reverse = false;
          sort_sensitive = true;

          show_hidden = true;
          show_symlink = true;
        };
      };

      theme = { };
      keymap = { };
    };

    # TODO: requires custom starship config
    initLua = let

      starship-config = ./starship-yazi.toml;
      #starship-config = pkgs.writeText "starthip.toml" /* toml */ ''
      #
      #'';

    in pkgs.writeText "init.lua" /* lua */ ''
      require("starship"):setup({
        -- Hide flags (such as filter, find and search). This can be beneficial for starship themes
        -- which are intended to go across the entire width of the terminal.
        --hide_flags = false,
        -- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
        --flags_after_prompt = false,
        -- Custom starship configuration file to use
        config_file = "${starship-config}", -- Default: nil
        -- Whether to enable support for starship's right prompt (i.e. `starship prompt --right`).
        show_right_prompt = false,
        -- Whether to hide the count widget, in case you want only your right prompt to show up. Only has
        -- an effect when `show_right_prompt = true`
        --hide_count = false,
        -- Separator to place between the right prompt and the count widget. Use `count_separator = ""`
        -- to have no space between the widgets.
        --count_separator = " ",
      })
    '';

    plugins = {
      inherit (pkgs.yaziPlugins)
        starship
      ;

      yazi-plugin-bat = pkgs.fetchFromGitHub {
        owner = "mgumz";
        repo = "yazi-plugin-bat";
        rev = "4dea0a584f30247b8ca4183dc2bd38c80da0d7ea";
        hash = "sha256-OPa8afKLZaBFL69pq5itI8xRg7u05FJthst88t6HZo0=";
      };
    };
  }
)

