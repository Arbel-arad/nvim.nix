{ pkgs, lib }: /* lua */ ''
  dap.adapters.bashdb = {
    type = 'executable';
    command = '${lib.getExe pkgs.bashdb}';
    name = 'bashdb';
  }

  dap.configurations.sh = {
    {
      type = 'bashdb',
      request = 'launch',
      name = "Launch file",
      showDebugOutput = true,
      --pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
      --pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
      trace = true,
      file = "$${file}",
      program = "$${file}",
      cwd = '$${workspaceFolder}',
      pathCat = "cat",
      pathBash = "/usr/bin/env bash",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      args = {},
      argsString = ''',
      env = {},
      terminalKind = "integrated",
    }
  }
''
