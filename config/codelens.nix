{ lib }: {

  autocmds = [
    {
      event = [
        "LspAttach"
      ];
      callback = lib.generators.mkLuaInline /* lua */ ''
        function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client:supports_method 'textDocument/codeLens' then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end
      '';
    }
  ];

  keymaps = [
    {
      key = "<leader>rc";
      mode = [
        "n"
      ];
      silent = true;

      lua = true;
      action = /* lua */ ''
        function()
          vim.lsp.codelens.run()
        end
      '';
      desc = "Run codelens";
    }
  ];
}
