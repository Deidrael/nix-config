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
  environment.systemPackages = with pkgs; [
    discord
    stable.openrct2
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "blade";
    fsBtrfs = true;
    hasNvidia = true;
    users.secondary.enable = true;
    role = {
      type = "workstation";
      gaming = true;
    };
    desktop = {
      displayManager = "gdm";
      gnome.enable = true;
    };
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
