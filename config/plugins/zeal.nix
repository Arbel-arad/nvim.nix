{ nvimSize, npins, pkgs, lib }: let

  enabled = nvimSize <= 10;

  zeal-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "zeal-nvim";
    version = "0";

    src = npins."zeal.nvim";

    patches = [
      ./patches/zeal-ro.patch
    ];
  };

  docsets = (import npins."zealdocs.nix" {
    inherit pkgs lib;
  }).fromSets [
    "C"
    "C++"
    "CMake"
    "Rust"
    "Bash"
    "Lua"
    "Go"
    "R"
    "Man_Pages"
    "Markdown"
    "contrib_Zig"
    "contrib_fish"
    "contrib_jq"
    "contrib_Neovim"
    "contrib_Linux_Man_Pages"
  ];

in {
  extraPackages = lib.optionals enabled [
    pkgs.w3m-nox
    pkgs.sqlite
  ];

  lazy = {
    plugins = {
      zeal-nvim = lib.mkIf enabled {
        package = zeal-nvim;

        setupModule = "zeal";
        setupOpts = {
          docsets_path = docsets;

          use_toggleterm = true;
          toggleterm = {
            direction = "float";
          };

          picker = {
            type = "snacks";
            snacks = {
              layout = "select";
            };
          };

          ft_map = {
            lua = [ "Lua" ];
            rust = [ "Rust" ];
            c = [ "C" ];
            cpp = [ "C" "C++" ];
            go = [ "Go" ];
            r = [ "R" ];
            bash = [ "Bash" ];
            fish = [ "contrib_fish" ];
            markdown = [ "Markdown" ];
            zig = [ "contrib_Zig" ];
            jq = [ "contrib_jq" ];
          };
        };

        lazy = true;
        cmd = [
          "Zeal"
          "ZealSearchFt"
          "ZealToggle"
        ];
      };
    };
  };
}
