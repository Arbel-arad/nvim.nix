{ npins, pkgs, lib }: let

  rp-python = pkgs.python3.withPackages (ps: [
    ps.railroad-diagrams
    ps.pillow
    ps.cairosvg
  ]);

in {
  extraPackages = [
    rp-python
  ];

  lazy = {
    plugins = let

      "nvim-regexplainer" = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-regexplainer";
        version = "0";

        src = npins."nvim-regexplainer";

        dependencies = [
          pkgs.vimPlugins.nvim-treesitter
          pkgs.vimPlugins.nui-nvim
        ];
      };

    in {
      "nui.nvim" = {
        package = pkgs.vimPlugins.nui-nvim;
      };

      "nvim-regexplainer" = {
        package = nvim-regexplainer;

        setupModule = "regexplainer";
        setupOpts = {
          mode = "narrative";
          auto = false;

          display = "popup";

          filetypes = [
            "rs"

            # Defaults
            "html"
            "js"
            "cjs"
            "mjs"
            "ts"
            "jsx"
            "tsx"
            "cjsx"
            "mjsx"
          ];


          deps = {
            auto_install = false;
            python_cmd = "${rp-python}/bin/python3";
          };

        };
      };
    };
  };
}
