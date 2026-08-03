{ pkgs }: {

  # Usage:
  # `jupyter console --kernel=python3 -f .direnv/kernel.json`
  # `:MoltenInit .direnv/kernel.json`
  # Init must be executed inside the target file

  python3Packages = [
    "pynvim"
    "jupytext"
    "jupyter-client"
    "cairosvg"
    "ipython"
    "nbformat"
    "ipykernel"

    "pnglatex"
    "plotly"
    "kaleido"

    "pyperclip"
  ];

  extraPackages = [
    pkgs.imagemagick
  ];

  luaPackages = [
    "magick"
  ];

  lazy = {
    plugins = {
      molten-nvim = {
        package = pkgs.molten-nvim-no-wezterm;

        # TODO: Still unclear on `:UpdateRemotePlugins`
        #setupModule = "Molten";
        setupOpts = {

        };
      };
    };
  };

  globals = {
    molten_image_provider = "image.nvim";
    molten_output_show_more = true;
    molten_output_virt_lines = true;
    molten_use_border_highlights = true;
  };
}
