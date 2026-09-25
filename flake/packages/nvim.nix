{ self, pkgs, lib, mkNvim }:pkgs.symlinkJoin {
  name = "nvim.nix";

  paths = [
    (mkNvim {
      size = 0;
    })
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  postBuild = let

    override-packages = [
      (import (self + /config/tools/fish.nix) { inherit pkgs; })
      (import (self + /config/tools/yazi.nix) { inherit pkgs; })
    ];

  in /* bash */ ''
    cp "$out/bin/nvim" "$out/bin/nvim-unwrapped"
    cp "$out/bin/nvim" "$out/bin/nvim-softwrapped"

    wrapProgram "$out/bin/nvim" \
      --set SHELL "fish" \
      --prefix PATH : "${lib.makeBinPath self.nvim-config.extraPackages}"

    wrapProgram "$out/bin/nvim-softwrapped" \
      --set SHELL "fish" \
      --prefix PATH : "${lib.makeBinPath override-packages}" \
      --suffix PATH : "${lib.makeBinPath self.nvim-config.extraPackages}"
  '';

  meta = {
    mainProgram = "nvim";
  };
}
