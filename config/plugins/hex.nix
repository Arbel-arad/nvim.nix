{ pkgs }: {
  lazy = {
    plugins = {
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
