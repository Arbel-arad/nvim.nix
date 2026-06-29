{ npins, system, pkgs }: let

  inherit ((import npins.rust-fenix { inherit system; }).minimal) toolchain;

  src = npins.ComChan;

in (pkgs.makeRustPlatform {
  cargo = toolchain;
  rustc = toolchain;
}).buildRustPackage {
  name = "ComChan";

  inherit src;

  cargoLock = {
    lockFile = src + /Cargo.lock;
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    eudev
    fontconfig.dev
  ];

    postInstall = let

      rpathLibs = with pkgs; [
        eudev
        fontconfig.lib
        freetype
      ];

    in /* bash */ ''
      patchelf --add-rpath "${pkgs.lib.makeLibraryPath rpathLibs}" "$out/bin/comchan"
    '';

  meta = {
    mainProgram = "comchan";
  };
}
