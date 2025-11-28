{ pkgs }: pkgs.rustPlatform.buildRustPackage {
  name = "colorprint";
  version = "1";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
}
