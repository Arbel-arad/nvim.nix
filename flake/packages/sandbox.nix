{ inputs, pkgs, nvim }: let

  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

in mkNixPak {
  config = { sloth, ... }: {
    dbus.enable = false;

    bubblewrap = {
      bind = {
        rw = [
          (sloth.env "PWD")
          (sloth.concat' "/run/user/" sloth.uid)
          (sloth.concat' sloth.homeDir "/.local")
          (sloth.concat' sloth.homeDir "/.cache")
        ];

        ro = [
          sloth.homeDir
        ];
      };
    };

    app = {
      package = nvim;
    };
  };
}
