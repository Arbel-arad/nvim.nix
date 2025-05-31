{ self' , pkgs }: {
  default = self'.apps."nvim.nix";
  "nvim.nix" = {
    type = "app";
    program = self'.packages.default;
  };
  gui = let
    neovideToml = import ../config/neovide.nix { inherit pkgs; };
  in {
    type = "app";
    program = pkgs.writeShellApplication {
      name = "nvf-wrapped";
      runtimeInputs = [
        pkgs.yazi
        pkgs.fish
      ];
      text = ''
        SHELL=${pkgs.fish}/bin/fish nvim --headless --listen localhost:7777 "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server=localhost:7777
      '';
    };
  };
}
