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
  ];

  # Minimal host spec
  hostSpec = {
    hostName = "nixbook";
  };

  # Basic networking
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
