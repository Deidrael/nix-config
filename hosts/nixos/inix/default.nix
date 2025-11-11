{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.apple-imac-14-2

    (lib.custom.relativeToRoot "modules/default.nix")
  ];

  hardware = {
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      prime.sync.enable = lib.mkForce false;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "inix";
    users = [
      config.hostSpec.primaryUsername
      config.hostSpec.secondaryUsername
    ];
    fsBtrfs = true;
    hasNvidia = false; # has Nvidia, but doesn't have iGPU so no Prime
    isWorkstation = true;
    desktop = {
      displayManager = "lightdm";
      cinnamon.enable = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };
  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    initrd = {
      systemd.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
