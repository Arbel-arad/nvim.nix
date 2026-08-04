{ pkgs, lib }: {
  extraPackages = [
    pkgs.octaveFull
  ];

  lsp = {
    servers = {
      matlab_lsp_server = let

        matlab-lsp = pkgs.python3Packages.buildPythonPackage {
          pname = "matlab-lsp-server";
          version = "0.3.2";

          format = "wheel";

          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/b0/76/214293bfa48835f7dc1a1ff031bf83cc78b363a0c9bd89c7255577603fa6/matlab_lsp_server-0.3.2-py3-none-any.whl";
            hash = "sha256-oXdoEDj9J6UU18y2jcqXY4kYst0B7mbjBJDCvbwYn/w=";
          };

          propagatedBuildInputs = with pkgs.python314Packages; [
            pygls
            lsprotocol
            aiofiles
            python-dateutil
            pydantic
            pydantic-settings
            cachetools
            colorlog
          ];
        };

      in {
        cmd = [
          "${matlab-lsp}/bin/matlab-lsp"
          "--stdio"
        ];

        filetypes = [
          "matlab"
        ];

        root_markers = [
          ".git"
          ".matlab-lsprc.json"
          "project.m"
        ];
      };
      #matlab_ls = {
      #  cmd = [
      #    "${lib.getExe pkgs.matlab-language-server}"
      #    "--stdio"
      #  ];

      #  filetypes = [
      #    "matlab"
      #  ];
      #};
    };
  };
}
