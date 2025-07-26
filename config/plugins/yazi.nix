{ pkgs }:{
  extraPlugins = {
    yazi-nvim = {
      package = pkgs.vimPlugins.yazi-nvim.overrideAttrs (_: prev: {  # TODO fix yazi paths
        patchPhase = prev.patchPhase or "" + /* bash */ ''

          sed -i -e 's|executable("ya")|executable("${pkgs.yazi}\/bin\/ya")|' lua/yazi/utils.lua
          sed -i -e 's|executable("yazi")|executable("${pkgs.yazi}\/bin\/yazi")|' lua/yazi/utils.lua
          sed -i -e 's|executable("ya")|executable("${pkgs.yazi}\/bin\/ya")|' lua/yazi/health.lua
          sed -i -e 's|executable("yazi")|executable("${pkgs.yazi}\/bin\/yazi")|' lua/yazi/health.lua
        '';
      });
    };
  };
}
