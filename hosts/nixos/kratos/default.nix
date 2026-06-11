{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "kratos";
    fsBtrfs = true;
    hasNvidiaPrime = true;
    role = {
      type = "workstation";
      gaming = true;
    };
    desktop = {
      displayManager = "sddm";
      hyprland = {
        enable = true;
        brightnessDevice = "acpi_video0";
      };
    };
    aiTools = true;
    threeDTools = true;
    podman = true;
    virtualMachines = true;
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
    initrd.systemd.enable = true;
    kernelModules = [
      "kvm-intel"
      "vfio-pci"
    ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [ "intel_iommu=on" ];
    kernelPackages = pkgs.linuxPackages_xanmod;
  };

  # NVIDIA PRIME — iGPU + dGPU bus IDs
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Battery saver boot option — disables NVIDIA dGPU at the hardware level
  hardware.nvidia.primeBatterySaverSpecialisation = true;

  # Swap on BTRFS subvolume
  swapDevices = [ { device = "/swap/swapfile"; } ];

}
