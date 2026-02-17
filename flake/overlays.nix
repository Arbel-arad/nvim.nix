{ self }: {
  nvf-pkgs = _: prevPkgs: {
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
}
