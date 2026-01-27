{ pkgs }: pkgs.wrapFish {
  runtimeInputs = [
    pkgs.starship
    pkgs.fd
  ];

  localConfig = /* fish */ ''
    set fish_greeting

    set STARSHIP_CONFIG ${./starship.toml}
    starship init fish | source
  '';

  pluginPkgs = with pkgs.fishPlugins; [
    fzf-fish
    autopair
  ];

  #completionDirs = [ ];
}
