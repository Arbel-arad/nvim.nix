{ nvimSize, pkgs, lib }: let

  enableExtra = nvimSize < 600;

  inherit (pkgs.vimPlugins) kulala-nvim;

  grammar = pkgs.tree-sitter.buildGrammar {
    inherit (kulala-nvim) version src meta;
    language = "kulala_http";
    location = "lua/tree-sitter";
  };

in {
  extraPackages = lib.optionals enableExtra (with pkgs; [
    curl
    grpcurl
    websocat
    openssl
    jq
    prettierd
    libxml2
    stylua
  ]);

  treesitter = {
    grammars = [
      grammar
    ];
  };

  lazy.plugins = {
    "${kulala-nvim.pname}" = {
      enabled = true;
      package = kulala-nvim;
      setupModule = "kulala";
      setupOpts = {
        global_keymaps = true;
        global_keymaps_prefix = "<leader>rh";
      };
      ft = [
        "http"
        "rest"
      ];
    };

    "rest.nvim" = {
      enabled = false;

      package = pkgs.vimPlugins.rest-nvim;
      setupOpts = {

      };

      lazy = true;

      ft = [
        "http"
      ];
    };
  };
}
