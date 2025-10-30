{ inputs, self }: let

  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};

in {
  test = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    modules = [
      inputs.microvm.nixosModules.microvm

      {
        microvm = {
          hypervisor = "qemu";

          balloon = true;

          graphics = {
            enable = true;
            backend = "gtk";
          };
          interfaces = [
            {
              type = "user";
              id = "test-vm";
              mac = "02:00:00:00:00:01";
            }
          ];
          shares = [
            {
              tag = "ro-store";
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
            }
          ];
        };

        services = {
          getty.autologinUser = "user";

          kmscon = {
            enable = true;
            autologinUser = "user";
          };
        };

        programs = {
          fish = {
            enable = true;
          };
        };

         fonts = {
            enableDefaultPackages = true;
            packages = with pkgs; [
              noto-fonts
              nerd-fonts.hack
            ];
          };

        users = {
          users.user = {
            password = "";
            group = "user";
            isNormalUser = true;
            extraGroups = [ "wheel" "video" ];
            shell = inputs.nixpkgs.legacyPackages.${system}.fish;
          };
          groups.user = { };
        };

        nix = {
          settings = {
            experimental-features = [ "nix-command" "flakes" ];
          } ;
        };

        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };

        hardware = {
          graphics = {
            enable = true;
          };
        };

        system = {
          stateVersion = pkgs.lib.trivial.release;
        };
      }
    ];
  };
}
