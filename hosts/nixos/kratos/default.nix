{
  inputs,
  config,
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

    (lib.custom.relativeToRoot "modules/default.nix")
  ];

  # ========== Computer Specific Packages ==========
  virtualisation.waydroid.enable = true;
  environment.systemPackages = with pkgs; [
    opencode
    space-cadet-pinball
    waydroid-helper
    zed-editor
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "kratos";
    fsBtrfs = true;
    hasNvidia = true;
    users = [ config.hostSpec.primaryUsername ];
    isWorkstation = true;
    isGaming = true;
    desktop = {
      displayManager = "sddm";
      hyprland.enable = true;
    };
    ollama = true;
    podman = true;
  };
  hardware.nvidia.primeBatterySaverSpecialisation = true;

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
