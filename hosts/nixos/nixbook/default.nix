{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    # ./keyboard.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    (lib.custom.relativeToRoot "modules/default.nix")
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "nixbook";
    users.secondary.enable = true;
    role = {
      type = "workstation";
    };
    desktop = {
      displayManager = "sddm";
      hyprland.enable = true;
    };
  };

  services.xserver.xkb.model = "chromebook";

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
