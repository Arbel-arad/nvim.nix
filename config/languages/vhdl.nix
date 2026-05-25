{ nvimSize, pkgs, lib }: let

  enabled = nvimSize < 300;

in {
  languages = {
    vhdl = {
      enable = true;

      lsp = {
        enable = false;
      };
    };
  };

  lsp = {
    servers = {
      vhdl_ls = lib.mkIf enabled {
        cmd = [
          "${pkgs.vhdl-ls}/bin/vhdl_ls"
        ];

        filetypes = [
          "vhdl"
        ];
      };
    };
  };
}
