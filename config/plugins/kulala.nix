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

    kulala-fmt
    kulala-core
  ]);

  treesitter = {
    grammars = lib.optionals enableExtra [
      # FIXME: Changed upstream?
      # https://github.com/mistweaverco/kulala.nvim/commit/e483050a54eb9d70ef733b06e129a8da8b3f1780
      #grammar
    ];
  };

  lazy.plugins = {
    "${kulala-nvim.pname}" = lib.mkIf enableExtra {
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
