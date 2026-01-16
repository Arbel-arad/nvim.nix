{ npins, pkgs, lib }: let

  tree-sitter-language-injection = pkgs.vimUtils.buildVimPlugin {
    pname = "tree-sitter-language-injection.nvim";
    version = "0";

    src = npins."tree-sitter-language-injection.nvim";
  };

in {
  lazy = {
    plugins = {
      "otter.nvim" = {

        package = pkgs.vimPlugins.otter-nvim;

        setupModule = "otter";

        setupOpts = {
          buffers = {
            set_filetype = true;
            #write_to_disk = true;
          };
          lsp = {
            diagnostic_update_event = [
              "BufWritePost"
              "InsertLeave"
            ];
          };
        };

        lazy = true;

        cmd = [
          "OtterActivate"
          "OtterDeactivate"
          "OtterExport"
          "OtterExportAs"
        ];

        keys = [
          {
            key = "<leader>loa";
            mode = [
              "n"
            ];

            desc = "Start Otter-ls";
            action = /* Lua */ "<cmd>lua require'otter'.activate()<cr>";
          }
          {
            key = "<leader>los";
            mode = [
              "n"
            ];

            desc = "Stop Otter-ls";
            action = /* Lua */ "<cmd>lua require'otter'.deactivate()<cr>";
          }
        ];
      };

      "tree-sitter-language-injection.nvim" = {
        package = tree-sitter-language-injection;

        setupModule = "tree-sitter-language-injection";

        setupOpts = {

        };

        before = /* Lua */ ''
          local config_path = vim.fn.stdpath("config")

          if vim.fn.isdirectory(config_path) == 0 then
            vim.fn.mkdir(config_path)
          end
        '';

        lazy = true;

        ft = [
          "python"
          "rust"
          "javascript"
          "typescript"
        ];
      };
    };
  };
}
