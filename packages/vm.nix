{ pkgs }: {
  crosvm-gui = pkgs.crosvm.overrideAttrs (final: prev: {
    buildFeatures = prev.buildFeatures ++ [ "gpu" "x" ];
  });
}
