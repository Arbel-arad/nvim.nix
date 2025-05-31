{ pkgs, ... }: {
  config = let
    formatTOML = pkgs.formats.toml {};
    "neovideToml" = formatTOML.generate "neovide.toml" {
      maximized = true;
      font = {
        normal = [];
        size = 10.0;
      };
    };

    "nvf-wrapped" = pkgs.writeShellScriptBin "nvf-wrapped" /* bash */ ''
      SHELL=${pkgs.fish}/bin/fish nvim --headless --listen localhost:6666 "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server=localhost:6666
    '';
  in {
    home = {
      packages = [
        pkgs.neovide
        nvf-wrapped
      ];
    };
    xdg = {
      desktopEntries = {
        nvim = {
          name = "Nvim";
          genericName = "Neovim wrapped";
          exec = "${nvf-wrapped}/bin/nvf-wrapped";
        };
      };
    };
  };
}
