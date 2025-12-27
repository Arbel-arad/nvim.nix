{ pkgs, nvf }: let
  neovideToml = (import ../config/neovide.nix { inherit pkgs; }).config;
in
pkgs.writeShellApplication {
  name = "nvf-wrapped";
  runtimeInputs = [
    pkgs.yazi
    pkgs.fish
  ];

  text = /* bash */ ''
    sockdir=$(mktemp -d)
    sockfile="$sockdir/nvim.sock"
    SHELL=${pkgs.fish}/bin/fish ${nvf}/bin/nvim --headless --listen "$sockfile" "$@" &
    while [[ ! -S "$sockfile" ]]; do
      sleep 0.1
    done
    NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide}/bin/neovide --server="$sockfile"
    if [ -S "$sockfile" ]; then rm "$sockdir/nvim.sock"; fi
    rmdir "$sockdir"
  '';
}

