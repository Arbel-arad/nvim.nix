{ npins, nvimSize, pkgs, lib }: let

  enabled = nvimSize <= 200;

in {
  options = {
    inccommand = "split";
  };
  extraPackages = lib.optionals enabled [
    pkgs.ast-grep
  ];

  lsp = {
    servers = {
      ast_grep = lib.mkIf enabled {
        cmd = [
          "${lib.getExe pkgs.ast-grep}" "lsp"
        ];
      };
    };
  };

  telescope = {
    extensions = lib.optionals enabled [
      {
        name = "ast_grep";
        packages = [ pkgs.vimPlugins.telescope-sg ];
        setup = {
          ast_grep = {
            command = [
              "${lib.getExe pkgs.ast-grep}"
              "--json=stream"
            ];
            grep_open_files = false;
            lang = null;
          };
        };
      }
    ];
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
