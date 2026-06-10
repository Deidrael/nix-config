{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "blade";
    fsBtrfs = true;
    hasNvidiaPrime = true;
    users.secondary.enable = true;
    role = {
      type = "workstation";
      gaming = true;
    };
    desktop = {
      displayManager = "gdm";
      gnome.enable = true;
    };
    desktopApps = {
      brave = true;
      firefox = true;
      social = true;
      media = true;
      tools = true;
    };
  };

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

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Battery saver boot option — disables NVIDIA dGPU at the hardware level
  hardware.nvidia.primeBatterySaverSpecialisation = true;

  # Swap on BTRFS subvolume
  swapDevices = [ { device = "/swap/swapfile"; } ];

  system.stateVersion = "24.05";
}
