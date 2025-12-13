{ self', pkgs, lib }: {
  nvf-zellij = pkgs.symlinkJoin {
    name = "nvf-zellij";

    paths = [
      pkgs.zellij
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = /* bash */ ''
      wrapProgram "$out/bin/zellij" \
        --add-flags "--config-dir ${./.} --new-session-with-layout nvim" \
        --prefix PATH : "${lib.makeBinPath [self'.packages."nvim.nix"]}"

      mv $out/bin/zellij $out/bin/nvf-zellij
    '';
  };
}
