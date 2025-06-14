{ pkgs, config, ... }: {
  config = let
    "neovideToml" = import ./config/neovide.nix { inherit pkgs; };
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
    systemd = let
      socket = "${config.home.homeDirectory}/.local/share/nvf.socket";
      program = pkgs.writeShellScriptBin "sock-wrap" /* bash */ ''

      '';

    in {
      user = {
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
        services = {
#           "nvf-wrapped@" = {
#             Service = {
#               ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen $REMOTE_ADDR";
#             };
#           };
          "nvf-wrapped" = {
            Service = {
              ExecStart = "${config.programs.nvf.finalPackage}/bin/nvim --headless --listen ${socket}";
            };
          };
        };
      };
    };
  };
}
