{ pkgs }:{
  lazy = {
    plugins = {
      "yazi.nvim" = {
        # TODO: fix yazi paths (this is shadowed by the global wrapper)
        package = pkgs.lib.mkDefault (pkgs.vimPlugins.yazi-nvim.overrideAttrs (_: prev: {
          patchPhase = prev.patchPhase or "" + /* bash */ ''

            sed -i -e 's|executable("ya")|executable("${pkgs.yazi}\/bin\/ya")|' lua/yazi/utils.lua
            sed -i -e 's|executable("yazi")|executable("${pkgs.yazi}\/bin\/yazi")|' lua/yazi/utils.lua
            sed -i -e 's|executable("ya")|executable("${pkgs.yazi}\/bin\/ya")|' lua/yazi/health.lua
            sed -i -e 's|executable("yazi")|executable("${pkgs.yazi}\/bin\/yazi")|' lua/yazi/health.lua
          '';
        }));
      };
    };
  };
}
