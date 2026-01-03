{ pkgs, lib }: /* lua */ ''
  local dap = require("dap")
  dap.adapters.gdb = {
    type = "executable",
    command = "${lib.getExe pkgs.gdb}",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  }
''
