{ self, self' , pkgs }: {

  default = self'.apps."nvim";

  nvim = {
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
    program = pkgs.callPackage (self + /flake/packages/nvim-gui.nix) {
      nvf = self'.packages.default;
      inherit self;
    };
    meta = {
      description = "Neovide GUI";
    };
  };

  gui-minimal = {
    type = "app";
    program = pkgs.callPackage (self + /flake/packages/nvim-gui.nix) {
      nvf = self'.packages.nvim-minimal;
      inherit self;
    };
    meta = {
      description = "Neovide GUI";
    };
  };

  sandbox = {
    type = "app";
    program = self'.packages.sandbox;
    meta = {
      description = "Neovim in a sandbox";
    };
  };

  oci = {
    type = "app";
    program = pkgs.writeShellApplication {
      name = "nvim-oci";

      runtimeInputs = [
        #pkgs.podman
      ];

      text = /* bash */ ''
        podman load < ${self'.packages.oci} && podman run -p 127.0.0.1:8082:8082 -it localhost/nvim:latest
      '';
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
