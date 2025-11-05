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
    users = [
      config.hostSpec.primaryUsername
      config.hostSpec.secondaryUsername
    ];
    isWorkstation = true;
    displayManager = "sddm";
    desktopHyprland = true;
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };
  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
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
