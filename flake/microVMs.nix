{ inputs, self }: {
  test = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.microvm.nixosModules.microvm

      {
        microvm = {
          hypervisor = "qemu";
          interfaces = [
            {
              type = "user";
              id = "test-vm";
              mac = "02:00:00:00:00:01";
            }
          ];
        };

        services = {
          getty.autologinUser = "user";
        };
        users = {
          users.user = {
            password = "";
            group = "user";
            isNormalUser = true;
            extraGroups = [ "wheel" "video" ];
          };
          groups.user = { };
        };
        security.sudo = {
          enable = true;
          wheelNeedsPassword = false;
        };
      }
    ];
  };
}
