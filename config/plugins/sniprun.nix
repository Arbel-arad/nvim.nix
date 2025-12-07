{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize <= 500;

in {
  extraPackages = lib.optionals enableExtra [
    pkgs.evcxr
  ];

  lazy = {
    plugins = {
      sniprun = {
        enabled = enableExtra;

        package = pkgs.vimPlugins.sniprun;

        setupModule = "sniprun";

        setupOpts = {
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

            TypeScript_original = {
              interpreter = "${lib.getExe pkgs.nodejs}";
            };

            SQL_original = {
              interpreter = "${lib.getExe pkgs.usql}";
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
