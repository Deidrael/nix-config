{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # Essential hardware from nixbook
    ../nixbook/hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # Core common modules - avoids workstation/desktop modules
    (lib.custom.relativeToRoot "modules/default.nix")
  ];

  # Minimal host spec
  hostSpec = {
    hostName = "nixbook-minimal";
  };

  # Basic networking
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  services.xserver.xkb.model = "chromebook";

  # Boot config
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    initrd.systemd.enable = true;
  };

  # Enable SSH for remote access
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
