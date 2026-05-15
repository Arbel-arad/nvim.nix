{ nvimSize, pkgs, lib }: let

  enabled = nvimSize < 300;

in {
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
