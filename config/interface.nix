_:{
  theme = {
    enable = true;
    name = "catppuccin";
    style = "mocha";
    transparent = false;
  };

  filetree = {
    neo-tree = {
      enable = true;
      setupOpts = {
        enable_cursor_hijack = true;
      };
    };
  };

  tabline = {
    nvimBufferline = {
      enable = true;
    };
  };

  minimap = {
    minimap-vim = {
      enable = false;
    };
    codewindow.enable = true;
  };

  statusline = {
    lualine = {
      enable = true;
      theme = "iceberg_dark";
      setupOpts = {
        options = {
          disabled_filetypes = rec {
            winbar = statusline;
            statusline = [
              # DAP-ui
              "dapui_breakpoints"
              "dapui_console"
              "dapui_watches"
              "dapui_scopes"
              "dapui_stacks"

              # DAP-view
              "dap-view-term"
              "dap-view"
              "dap-repl"

              # dashboards
              "dashboard"
              "startify"
              "alpha"
            ];
          };
        };
      };
    };
  };
}
