{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize < 300;

in {
  languages = {
    lua = {
      enable = true;

      extraDiagnostics = {
        enable = enableExtra;

        types = [
          "luacheck"
          "selene"
        ];
      };

      lsp = {
        enable = enableExtra;

        lazydev = {
          enable = true;
        };
      };
    };
  };

  lsp = {
    servers = {
      lua-language-server = lib.mkIf enableExtra {
        root_markers = [
          ".luarc.json"
          ".git"
        ];
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT";
            };

            workspace = {
              checkThirdParty = "Ask"; # ?
              library = [
                # This might be better defined per project
                # (.luarc.jsonc)
                (lib.generators.mkLuaInline /* lua */ "vim.env.VIMRUNTIME")
              ];
            };

            diagnostics = {
              globals = [
                #"vim"
              ];
            };
          };
        };
      };
    };
  };
}
