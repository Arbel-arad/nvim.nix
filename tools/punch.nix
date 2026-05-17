{ npins, pkgs }: let

  punch = npins."punch.lua";

in pkgs.luajit.pkgs.buildLuarocksPackage {
  pname = "punch";
  version = "0.3.2-1";

  src = punch;

  propagatedBuildInputs = [
    pkgs.rustls-libssl
    pkgs.luajitPackages.luv
  ];
}

