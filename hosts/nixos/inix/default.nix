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
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "inix";
    users.secondary.enable = true;
    fsBtrfs = true;
    hasNvidiaPrime = false; # has Nvidia, but doesn't have iGPU so no Prime
    role = {
      type = "workstation";
    };
    desktop = {
      displayManager = "lightdm";
      cinnamon.enable = true;
    };
  };

  # broadcom-sta is an insecure package — needed for WiFi on iMac14,2
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "broadcom-sta" ];

  boot = {
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
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

  # DHCP on all interfaces — previously in hardware-configuration.nix
  networking.useDHCP = lib.mkDefault true;

  # Swap on btrfs subvol — previously in hardware-configuration.nix
  swapDevices = [ { device = "/swap/swapfile"; } ];

  system.stateVersion = "24.05";
}
