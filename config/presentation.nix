{ nvimSize, pkgs, lib }: let

    enabled = nvimSize <= 900;

in {
  lazy = {
    plugins = {
      "screenkey.nvim" = lib.mkIf enabled (let

        screenkey = pkgs.vimUtils.buildVimPlugin {
          pname = "screenkey.nvim";
          version = "2.4.2";

          src = pkgs.fetchFromGitHub {
            owner = "NStefan002";
            repo = "screenkey.nvim";
            rev = "ffe868e737d16d07a9792c8e04568cf8a2644cb7";
            hash = "sha256-hVpIWF9M8Ef7Ku02hti1JS4e1vHwNk3gY9+1VZ6DB20=";
          };
        };

      in {
        inherit enabled;
        package = screenkey;

        setupModule = "screenkey";
        setupOpts = {
          win_opts = {
            row = 5;
            col = lib.generators.mkLuaInline /* lua */ "vim.o.columns - 5";
            anchor = "NE";

            width = 40;
            height = 1;

            title = "Inputs";
            title_pos = "center";

            focusable = false;
            noautocmd = true;
          };

          show_leader = false;


        };

        lazy = true;

        cmd = [
          "Screenkey"
        ];
      });
    };
  };
}
