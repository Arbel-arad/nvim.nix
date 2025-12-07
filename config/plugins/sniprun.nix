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

        setupOpts = if !enableExtra then {} else {
          repl_enable = [
            "Rust_original"
          ];

          interpreter_options = {
            Rust_original = {
              compiler = "${lib.getExe pkgs.rustc}";
            };

            TypeScript_original = {
              interpreter = "${lib.getExe pkgs.node}";
            };

            SQL_original = {
              interpreter = "${lib.getExe pkgs.usql}";
            };
          };
        };
      };
    };
  };
}
