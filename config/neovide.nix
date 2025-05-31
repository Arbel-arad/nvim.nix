{ pkgs }: let
  formatTOML = pkgs.formats.toml {};
in formatTOML.generate "neovide.toml" {
  maximized = true;
  font = {
    normal = [];
    size = 10.0;
  };
}
