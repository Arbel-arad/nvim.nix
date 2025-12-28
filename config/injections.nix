{ pkgs }: {
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
            action = /* lua */ "<cmd>lua require'otter'.activate()<cr>";
          }
          {
            key = "<leader>los";
            mode = [
              "n"
            ];

            desc = "Stop Otter-ls";
            action = /* lua */ "<cmd>lua require'otter'.deactivate()<cr>";
          }
        ];
      };
    };
  };
}
