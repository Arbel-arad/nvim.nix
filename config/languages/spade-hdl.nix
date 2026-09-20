{ npins, pkgs, lib }: {
  extraPackages = [
    pkgs.swim
  ];

  lsp = {
    servers = {
      spade-language-server = {
        cmd = [
          "${lib.getExe pkgs.swim}"
          "lsp"
        ];

        filetypes = [
          "spade"
        ];

        root_markers = [
          ".git"
          "swim.toml"
        ];
      };
    };
  };

  treesitter = {
    grammars = [
      (pkgs.callPackage ../../tools/tree-sitter-spade.nix { inherit npins; })
    ];
  };
}
