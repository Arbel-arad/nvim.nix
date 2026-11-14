{ self', pkgs, lib }: let

  zellij-config = pkgs.writeText "config.kdl" /* bash */ ''
    dangerously_allow_web_serving_without_a_certificate true
    web_server true
    web_server_ip "0.0.0.0"
  '';

  startup = pkgs.writeShellScriptBin "startup" /* bash */ ''
    zellij web --create-token
    zellij --config ${zellij-config} web
  '';


  contents = [
    pkgs.uutils-coreutils-noprefix
    pkgs.curl
    pkgs.bash
    pkgs.fish
    pkgs.nushell
    pkgs.zellij
    self'.packages.nvim-minimal

    startup
  ];

in
  pkgs.dockerTools.buildLayeredImage {
  name = "nvim";
  tag = "latest";

  inherit contents;

  extraCommands = /* bash */ ''
    mkdir -m 1777 tmp
    mkdir -p {.config}
  '';

  config = {
    Cmd = [
      "startup"
    ];

    Env = [
      "PATH=${lib.makeBinPath contents}"

      "TMPDIR=/tmp"
      "HOME=/"
      "SHELL=fish"
      "EDITOR=nvim"

      "XDG_CACHE_HOME=/.cache"
      "XDG_CONFIG_HOME=/.config"
    ];
  };
}
