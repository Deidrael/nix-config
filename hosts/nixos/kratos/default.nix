{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./boot.nix
    ./drives.nix
    ./nvidia.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "kratos";
    fsBtrfs = true;
    hasNvidia = true;
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
    initrd = {
      systemd.enable = true;
    };
  };

  # Battery saver boot option — disables NVIDIA dGPU at the hardware level
  hardware.nvidia.primeBatterySaverSpecialisation = true;

  system.stateVersion = "24.05";
}
