{ self', pkgs, lib }: {
  nvim-zellij = pkgs.symlinkJoin {
    name = "nvim-zellij";

    paths = [
      pkgs.zellij
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = let

      mkPluginBind = args: let

        keys = lib.concatMapStrings (x: ''"${x}" '') args.keys;
        name = args.name or "bind";
        inherit (args) dir;


      in /* bash */ ''
        bind ${keys} {
              MessagePlugin "file:${vim-zellij-navigator}" {
                name "${name}";
                payload "${dir}";
              };
            }
      '';

      vim-zellij-navigator = builtins.fetchurl {
        url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
        sha256 = "13f54hf77bwcqhsbmkvpv07pwn3mblyljx15my66j6kw5zva5rbp";
      };

      config = pkgs.writeText "config.kdl" /* bash */ ''
        default_layout "nvim"

        default_mode "locked"

        default_shell "fish"

        show_startup_tips false
        show_release_notes false

        keybinds {
          locked {
            bind "Alt h" "Alt Left" { MoveFocus "Left"; }
            bind "Alt l" "Alt Right" { MoveFocus "Right"; }
            bind "Alt j" "Alt Down" { MoveFocus "Down"; }
            bind "Alt k" "Alt Up" { MoveFocus "Up"; }

            ${mkPluginBind { keys = [ "Ctrl h" ]; name = "move_focus_or_tab"; dir = "left"; }}
            ${mkPluginBind { keys = [ "Ctrl j" ]; name = "move_focus"; dir = "down"; }}
            ${mkPluginBind { keys = [ "Ctrl k" ]; name = "move_focus"; dir = "up"; }}
            ${mkPluginBind { keys = [ "Ctrl l" ]; name = "move_focus_or_tab"; dir = "right"; }}
          }
        }
      '';

    in /* bash */ ''
      wrapProgram "$out/bin/zellij" \
        --add-flags "--config-dir ${./.} --config ${config} --new-session-with-layout nvim" \
        --prefix PATH : "${lib.makeBinPath [self'.packages."nvim.nix"]}"

      mv $out/bin/zellij $out/bin/nvim-zellij
    '';
  };
}
