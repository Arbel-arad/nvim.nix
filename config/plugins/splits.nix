{ npins, pkgs, lib }: let

  vim-zellij-navigator-broken = let

    src = npins."vim-zellij-navigator";

  in pkgs.rustPlatform.buildRustPackage {
    name = "vim-zellij-navigator";
    version = "0";

    inherit src;

    cargoLock = {
      lockFile = src + /Cargo.lock;
    };

    buildInputs = [
      pkgs.openssl
    ];

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    env = {
      PKG_CONFIG_PATH = lib.getExe pkgs.pkg-config;
    };
  };

  vim-zellij-navigator = builtins.path {
    name = "vim-zellij-navigator";

    path = builtins.fetchurl {
      url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
      sha256 = "13f54hf77bwcqhsbmkvpv07pwn3mblyljx15my66j6kw5zva5rbp";
    };
  };

in {

  config = {
    utility = {
      smart-splits = {
        enable = true;

        keymaps = {

        };

        setupOpts = {

        };
      };
    };
  };
}
