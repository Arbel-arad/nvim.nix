{ npins, pkgs }: let

  puml-lsp = pkgs.buildGoLatestModule {
    name = "plantuml-lsp";

    src = npins.plantuml-lsp;
    vendorHash = null;
  };

in {
  extraPackages = [
    pkgs.plantuml-c4
    puml-lsp

    pkgs.feh
    pkgs.imv
  ];

  lsp = {
    servers = {
      plantuml_lsp = {
        root_markers = [
          ".git"
        ];

        cmd = [
          "${puml-lsp}/bin/plantuml-lsp"
          "--stdlib-path=${npins.plantuml-stdlib}"
          "--exec-path=plantuml"
        ];

        filetypes = [
          "plantuml"
        ];
      };
    };
  };

  lazy = {
    plugins = {
      plantuml-syntax = {
        package = pkgs.vimPlugins.plantuml-syntax;

        lazy = true;

        ft = [
          "plantuml"
        ];
      };

      "preview-nvim" = {
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "preview-nvim";
          version = "0";

          src = npins."itaranto/preview.nvim";
        };

        setupModule = "preview";
        setupOpts = {
          previewers_by_ft = {
            plantuml = {
              name = "plantuml_png";
              renderer = {
                type = "image_nvim";
                opts = {
                  ext = "png";
                };
              };
            };
          };

          render_on_write = true;
        };

        lazy = true;

        ft = [
          "plantuml"
        ];
      };
    };
  };

  luaConfigRC = {
    filetypes-puml = /* lua */ ''
      vim.filetype.add({
        extension = {
          puml = 'plantuml',
          plantuml = 'plantuml',
          pu = 'plantuml',
          uml = 'plantuml',
          iuml = 'plantuml',
        }
      })
    '';
  };
}
