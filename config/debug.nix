{ nvimSize, pkgs, lib }:{
  debugger = {
    nvim-dap = {
      enable = true;
      ui = {
        enable = true;
      };
      sources = {
        clang-debugger = lib.mkForce /* lua */ ''
          dap.adapters.lldb = {
            type = 'executable',
            command = '${pkgs.clang-tools}/bin/lldb-dap',
            name = 'lldb'
          }
          dap.configurations.cpp = {
            {
              name = 'Launch',
              type = 'lldb',
              request = 'launch',
              console = "integratedTerminal",
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = "''${workspaceFolder}",
              stopOnEntry = false,
              args = {},
            },
            {
              name = "LaunchWithArgs",
              type = "lldb",
              request = "launch",
              console = "integratedTerminal",
              args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, " +")
              end,
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              stopOnEntry = true,
              runInTerminal = false,
            },
            {
              name = "LaunchConsole",
              type = "lldb",
              request = "launch",
              console = "integratedTerminal",
              args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, " +")
              end,
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              stopOnEntry = true,
              runInTerminal = true,
            },
          }
          dap.configurations.c = dap.configurations.cpp
        '';
      };
    };
  };
}
