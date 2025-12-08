{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 500;

in {
  extraPackages = lib.optionals enableExtra [

    # Rust
    pkgs.evcxr

    pkgs.lua

    pkgs.R
  ];

  lazy = {
    plugins = {
      sniprun = {
        enabled = enableExtra;

        package = pkgs.vimPlugins.sniprun;

        setupModule = "sniprun";

        setupOpts = if !enableExtra then { } else {
          repl_enable = [
            "Rust_original"
          ];

          display = [
            "VirtualLineOk"
            "TempFloatingWindowErr"
            "NvimNotify"
          ];

          display_options = {
            terminal_position = "horizontal";
            notification_timeout = 10;
          };

          interpreter_options = {
            Rust_original = {
              compiler = "${pkgs.rustc}/bin/rustc";
            };

            C_original = {
              compiler = "${lib.getExe pkgs.gcc_latest}";
            };

            TypeScript_original = {
              interpreter = "${lib.getExe pkgs.nodejs}";
            };

            SQL_original = {
              interpreter = "${lib.getExe pkgs.usql}";
            };

            Lua_original = {
              interpreter = "${lib.getExe pkgs.lua}";
            };

            R_original = {
              interpreter = "${pkgs.R}/bin/Rscript";
            };

            OrgMode_original = {
              default_filetype = "bash";
            };

            Neorg_original = {
              default_filetype = "bash";
            };
          };
        };
      };
    };
  };
}
