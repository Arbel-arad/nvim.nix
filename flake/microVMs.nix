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
          storeDiskType = "squashfs";

          mem = 8192;
          vcpu = 8;

          vsock = {
            cid = 1234;
          };

          graphics = {
            enable = true;
            backend = "gtk-gpu";
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

          devices = [
            # Requires host configuration
            #{ bus = "usb"; path = "vendorid=0x0781,productid=0x5566"; }
          ];

         qemu.extraArgs = [
            # needed for mouse/keyboard input via vnc
            "-device" "virtio-keyboard"
            "-usb"
            "-device" "usb-tablet,bus=usb-bus.0"
          ];
        };

        documentation = {
          enable = false;
          man = {
            enable = false;
          };
        };

        services = {
          getty.autologinUser = "user";

          kmscon = {
            enable = false;
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

        environment = {
          systemPackages = [
            pkgs.xdg-utils
            pkgs.ghostty
            pkgs.sway
            pkgs.hyprland
            pkgs.btop
            #pkgs.sommelier
            pkgs.wayland-proxy-virtwl
          ];
          sessionVariables = {
            WAYLAND_DISPLAY = "wayland-1";
            DISPLAY = ":0";
            QT_QPA_PLATFORM = "wayland"; # Qt Applications
            GDK_BACKEND = "wayland"; # GTK Applications
            XDG_SESSION_TYPE = "wayland"; # Electron Applications
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
          };
        };

        systemd.user.services.wayland-proxy = {
          enable = false;
          description = "Wayland Proxy";
          serviceConfig = with pkgs; {
            # Environment = "WAYLAND_DISPLAY=wayland-1";
            ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
            Restart = "on-failure";
            RestartSec = 5;
          };
          wantedBy = [ "default.target" ];
        };
      }
    ];
  };
}
