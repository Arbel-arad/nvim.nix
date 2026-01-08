{ pkgs, lib }: {
  lazy = {
    plugins = {
      "hex.nvim" = let

        xxd-bin = lib.getExe pkgs.tinyxxd;

      in {
        package = pkgs.vimPlugins.hex-nvim;

        setupModule = "hex";
        setupOpts = {
          dump_cmd = "${xxd-bin} -g 1 -u";
          assemble_cmd = "${xxd-bin} -r";
        };

        lazy = true;

        cmd = [
          "HexDump"
          "HexAssemble"
          "HexToggle"
        ];
      };

      "compiler-explorer.nvim" = {
        package = pkgs.vimPlugins.compiler-explorer-nvim;

        setupModule = "compiler-explorer";
        setupOpts = {
          # Need to install self-hosted compile server
          #url = ""

          line_match = {
            highlight = true;
            jump = false;
          };

          open_qflist = true;
        };

        lazy = true;

        cmd = [
          "CECompile"
          "CECompileLive"
          "CEFormat"
          "CEAddLibrary"
          "CELoadExample"
          "CEOpenWebsite"
          "CEDeleteCache"
          "CEShowTooltip"
          "CEGotoLabel"
        ];
      };
    };
  };
}
