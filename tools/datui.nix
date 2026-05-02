{ npins, pkgs }: let

  datui-src = npins.datui;

in pkgs.rustPlatform.buildRustPackage {
  name = "datui";

  src = datui-src;

  cargoLock = {
    lockFile = datui-src + /Cargo.lock;
  };

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.fontconfig.dev
  ];

  # FIXME:
  # The tests need extra python packages
  doCheck = false;

  meta = {
    mainProgram = "datui";
  };
}
