{ nvimSize }:{
  formatter = {
    conform-nvim = {
      enable = true;
    };
  };
  keymaps = [
    {
      desc = "Conform format";
      key = "<leader>ltr";
      mode = [ "n" ];
      lua = true;

      action = /* Lua */ ''
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          })
        end
      '';
    }
  ];
}
