{
  inputs,
  lib,
  pkgs,
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

  # Boot config
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    initrd.systemd.enable = true;
  };

  # Chromebook keyboard quirks
  services.xserver.xkb.model = "chromebook";

  swapDevices = [ { device = "/dev/disk/by-uuid/26c93dda-2270-4044-b2fc-c94e48832c9a"; } ];

  system.stateVersion = "24.05";
}
