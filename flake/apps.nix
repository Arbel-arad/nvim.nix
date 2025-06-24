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
        sockfile="$sockdir/nvim.sock"
        SHELL=${pkgs.fish}/bin/fish nvim --headless --listen "$sockfile" "$@" & NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server="$sockfile"
        if [ -S "$sockfile" ]; then rm "$sockdir/nvim.sock"; fi
        rmdir "$sockdir"
      '';
    };
  };
}
