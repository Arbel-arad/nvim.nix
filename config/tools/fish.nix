{ pkgs }: pkgs.wrapFish {
  runtimeInputs = [
    pkgs.starship
  ];

  localConfig = /* fish */ ''
    set fish_greeting

    set STARSHIP_CONFIG ${./starship.toml}
    starship init fish | source
  '';
}
