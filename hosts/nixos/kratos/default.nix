{
  inputs,
  lib,
  pkgs,
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

  # ========== Computer Specific Packages ==========
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  environment.systemPackages = with pkgs; [
    waydroid-helper
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
  };
  hardware.nvidia.primeBatterySaverSpecialisation = true;

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
