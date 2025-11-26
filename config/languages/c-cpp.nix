{ nvimSize, pkgs, lib }: {
  lazy = {
    plugins = {
      "ccls-nvim" = {
        enabled = true;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "ccls-nvim";
          version = "0";

          src = pkgs.fetchFromGitHub {
            owner = "ranjithshegde";
            repo = "ccls.nvim";
            rev = "4b258c269d58cc5e37e55cf2316074e2740e5f57";
            hash = "sha256-o1U+F1F2TTBZ3ViG77wvc3D92rwfQFoCol+vD5WWxXM=";
          };

          dependencies = [
            pkgs.ccls
          ];
        };

        setupModule = "ccls";
        setupOpts = {
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "opencl"
          ];

          lsp = {
            server = {
              name = "ccls";
              cmd = [
                "${lib.getExe pkgs.ccls}"
              ];
              args = [ ];
              offset_encoding = "utf-32";
              root_dir = lib.generators.mkLuaInline /* lua */ ''
                vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1])
              '';
            };
            codelens = {
              enable = true;
              events = [
                "BufWritePost"
                "InsertLeave"
              ];
            };

            # Clang compatibility
            disable_capabilities = {
              completionProvider = true;
              documentFormattingProvider = true;
              documentRangeFormattingProvider = true;
              documentHighlightProvider = true;
              documentSymbolProvider = true;
              workspaceSymbolProvider = true;
              renameProvider = true;
              hoverProvider = true;
              codeActionProvider = true;
            };
            disable_diagnostics = true;
            disable_signature = true;
          };
        };

        lazy = false; ### TODO fix lazy load
        ft = [
          "cpp"
          "objc"
          "objcpp"
        ];
      };
    };
  };
}
