# a lot of this is just the auto-generated files from https://github.com/elitak/nixos-infect
args @ {
  config,
  lib,
  modulesPath,
  ...
}:
with lib; let
  cfg = config.dots.nixosModules.digitalocean;
in {
  options.dots.nixosModules.digitalocean = {
    enable = mkEnableOption (mdDoc "Enables configuration for DigitalOcean droplets.");
  };

  config = mkIf cfg.enable (
    # (import (modulesPath + "/profiles/qemu-guest.nix") args) //
  {
    nixpkgs-profiles.qemu-guest.enable = true;

    boot = {
      loader.grub.device = "/dev/vda";

      initrd = {
        availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
        kernelModules = ["nvme"];
      };
    };

    fileSystems."/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };

    networking = {
      nameservers = ["8.8.8.8"];
      defaultGateway = "138.197.0.1";

      defaultGateway6 = {
        address = "";
        interface = "eth0";
      };

      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;

      interfaces = {
        eth0.ipv4 = {
          addresses = [
            {
              address = "138.197.14.80";
              prefixLength = 20;
            }
            {
              address = "10.17.0.5";
              prefixLength = 16;
            }
          ];
          routes = [
            {
              address = "138.197.0.1";
              prefixLength = 32;
            }
          ];
        };

        eth0.ipv6 = {
          addresses = [
            {
              address = "fe80::f8b6:c6ff:fead:38a";
              prefixLength = 64;
            }
          ];
          routes = [
            {
              address = "";
              prefixLength = 128;
            }
          ];
        };

        eth1.ipv4.addresses = [
          {
            address = "10.108.0.2";
            prefixLength = 20;
          }
        ];

        eth1.ipv6.addresses = [
          {
            address = "fe80::44d4:f5ff:fe22:aee2";
            prefixLength = 64;
          }
        ];
      };
    };

    services.udev.extraRules = ''
      ATTR{address}=="fa:b6:c6:ad:03:8a", NAME="eth0"
      ATTR{address}=="46:d4:f5:22:ae:e2", NAME="eth1"
    '';
  });
}
