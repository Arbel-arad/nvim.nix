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
      text = /* bash */ ''
        sockdir=$(mktemp -d)
        SHELL=${pkgs.fish}/bin/fish nvim --headless --listen "$sockdir/nvim.sock" "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server="$sockdir/nvim.sock"
        rm "$sockdir/nvim.sock" || echo "nvim removed socket"
        rmdir "$sockdir"
      '';
    };
  };
}
