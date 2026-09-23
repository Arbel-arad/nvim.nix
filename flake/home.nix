{ pkgs, config, ... }: {
  config = let
    nvim-gui = pkgs.callPackages ../flake/packages/nvim-gui.nix {
      nvf = config.programs.nvf.finalPackage;
      self = ../.;
    };
#     "nvim-gui" = pkgs.writeShellScriptBin "nvim-gui" /* bash */ ''
#       SHELL=${pkgs.fish}/bin/fish nvim --headless --listen localhost:6666 "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server=localhost:6666
#     '';
  in {
    home = {
      packages = [
        nvim-gui
      ];
    };
    xdg = {
      desktopEntries = {
        nvim-gui = {
          name = "nvim-gui";
          genericName = "Neovim GUI";
          type = "Application";
          terminal = false;
          exec = "${nvim-gui}/bin/nvim-gui";
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
#           nvim-gui = {
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
#           "nvim-gui@" = {
#             Service = {
#               ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen $REMOTE_ADDR";
#             };
#           };
#           "nvim-gui" = {
#             Service = {
#               ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen ${socket}";
#             };
#           };
#         };
#       };
#     };
  };
}
