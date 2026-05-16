{ self }: {
  common = _: prevPkgs: {
    black = prevPkgs.black.overrideAttrs (prev: {
      patches = prev.patches ++ [
       (self + /config/languages/patches/black-indent.patch)
      ];

      nativeCheckInputs = [];

      doCheck = false;

      pytestCheckPhase = ''
        echo "this is broken"
      '';
    });
  };

  nvf-pkgs = _: prevPkgs: let

      pkgs = prevPkgs;

    in {
    rustfmt = prevPkgs.lib.makeOverridable ({asNightly}: (prevPkgs.symlinkJoin {
      name = "rustfmt";

      paths = [
        (prevPkgs.rustfmt.override { inherit asNightly; })
      ];

      buildInputs = [
        prevPkgs.makeWrapper
      ];

      postBuild = /* bash */ ''
        mkdir -p "$out/config/rustfmt/"

        ln -s ${pkgs.writers.writeTOML "rustfmt.toml" {
          tab_spaces = 2;
          max_width = 1000;
        }} "$out/config/rustfmt/rustfmt.toml"

        wrapProgram "$out/bin/rustfmt" \
          --set XDG_CONFIG_HOME "$out/config"
      '';

      meta = {
        mainProgram = "rustfmt";
      };
    })) { asNightly = false; };
  };
}
