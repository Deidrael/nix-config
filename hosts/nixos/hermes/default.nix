{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "hermes";
    role = {
      type = "server";
    };
    tailscale.routingFeatures = "both";
    nfsClient.enable = true;
    podman = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault false;
      efi.canTouchEfiVariables = lib.mkDefault false;
      timeout = 3;
    };
    #initrd.systemd.enable = true;
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  swapDevices = [ ];

  system.stateVersion = "24.05";
}
