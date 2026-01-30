{ npins, pkgs }: {
  options = {
    inccommand = "split";
  };

  lazy = {
    plugins = {
      "searchbox.nvim" = {
        package = pkgs.vimPlugins.searchbox-nvim;

        lazy = true;

        cmd = [
          "SearchBoxIncSearch"
          "SearchBoxMatchAll"
          "SearchboxClear"
          "SearchBoxSimple"
          "SearchBoxReplace"
          "SearchBoxReplaceLast"
        ];
      };

      "search-replace.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "search-replace.nvim";
          version = "0";

          src = npins."search-replace.nvim";
        };

        setupModule = "search-replace";
        setupOpts = {
          default_replace_single_buffer_options = "gcI";
          default_replace_multi_buffer_options = "egcI";
        };

        lazy = false;

        cmd = [
          "SearchReplaceSingleBufferOpen"
          "SearchReplaceMultiBufferOpen"

          "SearchReplaceSingleBufferCWord"
          "SearchReplaceSingleBufferCWORD"
          "SearchReplaceSingleBufferCExpr"
          "SearchReplaceSingleBufferCFile"

          "SearchReplaceMultiBufferCWord"
          "SearchReplaceMultiBufferCWORD"
          "SearchReplaceMultiBufferCExpr"
          "SearchReplaceMultiBufferCFile"

          "SearchReplaceSingleBufferSelections"
          "SearchReplaceMultiBufferSelections"

          "SearchReplaceSingleBufferWithinBlock"

          "SearchReplaceVisualSelection"
          "SearchReplaceVisualSelectionCWord"
          "SearchReplaceVisualSelectionCWORD"
          "SearchReplaceVisualSelectionCExpr"
          "SearchReplaceVisualSelectionCFile"
        ];
      };

      "grug-far.nvim" = {
        package = pkgs.vimPlugins.grug-far-nvim;

        setupModule = "grug-far";
        setupOpts = {

        };

        lazy = true;

        cmd = [
          "GrugFar"
          "GrugFarWithin"
        ];
      };
    };
  };
}
