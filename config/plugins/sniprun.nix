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
          selected_interpreters = [
            "Lua_nvim"
            "Ada_original"
            "Bash_original"
            "CS_original"
            "CSharp_original"
            "C_original"
            "Clojure_fifo"
            "Cpp_original"
            "D_original"
            "Elixir_original"
            "FSharp_fifo"
            "GFM_original"
            "Generic"
            "Go_original"
            "Haskell_original"
            "Http_original"
            "JS_TS_bun"
            "JS_TS_deno"
            "JS_original"
            "Java_original"
            "Julia_jupyter"
            "Julia_original"
            "Mathematica_original"
            "Neorg_original"
            "OCaml_fifo"
            "OrgMode_original"
            "PHP_original"
            "Plantuml_original"
            "Prolog_original"
            "Python3_fifo"
            "Python3_jupyter"
            "Python3_original"
            "R_original"
            "Ruby_original"
            "Rust_original"
            "SQL_original"
            "Sage_fifo"
            "Scala_original"
            "Swift_original"
            "TypeScript_original"
          ];

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
