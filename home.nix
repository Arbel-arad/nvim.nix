{ pkgs, config, ... }: {
  config = let
    nvf-wrapped = import ./packages/nvf-wrapped.nix { inherit pkgs; nvf = config.programs.nvf.finalPackage;};
#     "nvf-wrapped" = pkgs.writeShellScriptBin "nvf-wrapped" /* bash */ ''
#       SHELL=${pkgs.fish}/bin/fish nvim --headless --listen localhost:6666 "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server=localhost:6666
#     '';
  in {
    home = {
      packages = [
        nvf-wrapped
      ];
    };
    xdg = {
      desktopEntries = {
        nvf-wrapped = {
          name = "nvf-wrapped";
          genericName = "Neovim GUI";
          type = "Application";
          terminal = false;
          exec = "${nvf-wrapped}/bin/nvf-wrapped";
          settings = {
            Keywords = "nvim;nvf;neovim;neovide";
          };
          icon = "${pkgs.neovide}/share/icons/hicolor/scalable/apps/neovide.svg";
          categories = [
            "Development"
            "TextEditor"
            "IDE"
          ];
          mimeType = [
            "text/*"
          ];
        };
      };
    };
#     systemd = let
#       socket = "${config.home.homeDirectory}/.local/share/nvf.socket";
#       program = pkgs.writeShellScriptBin "sock-wrap" /* bash */ ''
#
#       '';
#     in {
#       user = {
#         sockets = {
#           nvf-wrapped = {
#             Unit = {
#               Description = "Neovim flake GUI wrapper";
#             };
#             Socket = {
#               Accept = true;
#               ListenStream = socket;
#             };
#           };
#         };
#         services = {
#           "nvf-wrapped@" = {
#             Service = {
#               ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen $REMOTE_ADDR";
#             };
#           };
#           "nvf-wrapped" = {
#             Service = {
#               ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen ${socket}";
#             };
#           };
#         };
#       };
#     };
  };
}
