{ pkgs }: {
  globals = {
    neovide_scale_factor = 0.7;
    neovide_cursor_animation_length = 0.1;
    neovice_cursor_short_animation_length = 0;
  };

  config = (pkgs.formats.toml {}).generate "neovide.toml" {
    maximized = true;
    font = {
      normal = [];
      size = 10.0;
    };
  };
}
