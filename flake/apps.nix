{ self, self' , pkgs }: {

  default = self'.apps."nvim.nix";

  "nvim.nix" = {
    type = "app";
    program = self'.packages.default;
    meta = {
      description = "Neovim";
    };
  };

  nvim-unwrapped = {
    type = "app";
    program = self'.packages.default // {
      meta = {
        mainProgram = "nvim-unwrapped";
      };
    };
    meta = {
      description = "Neovim, unwrapped";
    };
  };

  nvim-softwrapped = {
    type = "app";
    program = self'.packages.default // {
      meta = {
        mainProgram = "nvim-softwrapped";
      };
    };
    meta = {
      description = "Neovim with a soft wrapper that respects the environment";
    };
  };

  nvim-zellij = {
    type = "app";
    program = self'.packages.nvim-zellij;
    meta = {
      description = "Neovim in zellij";
    };
  };

 nvim-minimal = {
    type = "app";
    program = self'.packages.nvim-minimal;
    meta = {
      description = "Neovim minimal configuration";
    };
  };

  gui = {
    type = "app";
    program = import (self + /packages/nvf-wrapped.nix) {
      inherit pkgs;
      nvf = self'.packages.default;
    };
    meta = {
      description = "Neovide GUI";
    };
  };

  gui-minimal = {
    type = "app";
    program = import (self + /packages/nvf-wrapped.nix) {
      inherit pkgs;
      nvf = self'.packages.nvim-minimal;
    };
    meta = {
      description = "Neovide GUI";
    };
  };

  print-config = {
    type = "app";
    program = "${self'.packages.default}/bin/nvf-print-config";
    meta = {
      description = "nvf-print-config";
    };
  };
}
