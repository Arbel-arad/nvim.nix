{ self, self', pkgs, lib }: {
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

      # Keybinds matched with Neovim
      config = pkgs.writeText "config.kdl" /* c */ ''
        default_layout "nvim"

        //default_mode "locked"

        default_shell "fish"

        show_startup_tips false
        show_release_notes false

        keybinds {
          shared_except "locked" {
            ${mkPluginBind { keys = [ "Ctrl Alt h" "Ctrl Alt Left"  ]; name = "move_focus_or_tab"; dir = "left"; }}
            ${mkPluginBind { keys = [ "Ctrl Alt j" "Ctrl Alt Down" ]; name = "move_focus"; dir = "down"; }}
            ${mkPluginBind { keys = [ "Ctrl Alt k" "Ctrl Alt U"  ]; name = "move_focus"; dir = "up"; }}
            ${mkPluginBind { keys = [ "Ctrl Alt l" "Ctrl Alt Right"    ]; name = "move_focus_or_tab"; dir = "right"; }}

            ${mkPluginBind { keys = [ "Alt h" "Alt Left"  ]; name = "resize"; dir = "left"; }}
            ${mkPluginBind { keys = [ "Alt j" "Alt Down" ]; name = "resize"; dir = "down"; }}
            ${mkPluginBind { keys = [ "Alt k" "Alt Up"  ]; name = "resize"; dir = "up"; }}
            ${mkPluginBind { keys = [ "Alt l" "Alt Right"    ]; name = "resize"; dir = "right"; }}
          }
        }
      '';

    in /* bash */ ''
      wrapProgram "$out/bin/zellij" \
        --add-flags "--config-dir ${./.} --config ${config} --new-session-with-layout nvim" \
        --prefix PATH : "${ lib.makeBinPath ([
          self'.packages."nvim.nix"
        ] ++ self.nvim-config.extraPackages) }"

      mv $out/bin/zellij $out/bin/nvim-zellij
    '';

    meta = {
      mainProgram = "nvim-zellij";
    };
  };
}
