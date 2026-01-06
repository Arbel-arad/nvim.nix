{ npins, nvimSize, pkgs, lib }: let

    enabled = nvimSize <= 900;

in {
  lazy = {
    plugins = {
      "screenkey.nvim" = lib.mkIf enabled (let

        screenkey = pkgs.vimUtils.buildVimPlugin {
          pname = "screenkey.nvim";
          version = "2.4.2";

          src = npins."screenkey.nvim";
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
