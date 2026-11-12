{ self, pkgs, nvf }: let

  neovideToml = (import (self + /config/neovide.nix) {
    inherit pkgs;
  }).config;

in
pkgs.writeShellApplication {
  name = "nvim-gui";

  runtimeInputs = [
    pkgs.yazi
    pkgs.fish
  ];

    #FIXME:
  text = /* bash */ ''
    sockdir=$(mktemp -d)
    sockfile="$sockdir/nvim.sock"
    SHELL=${pkgs.fish}/bin/fish ${nvf}/bin/nvim --headless --listen "$sockfile" "$@" &
    while [[ ! -S "$sockfile" ]]; do
      sleep 0.1
    done
    NEOVIDE_CONFIG=${neovideToml} ${pkgs.neovide.overrideAttrs {doCheck = false; }}/bin/neovide --server="$sockfile"
    if [ -S "$sockfile" ]; then rm "$sockdir/nvim.sock"; fi
    rmdir "$sockdir"
  '';
}

