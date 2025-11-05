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
    ./network.nix
    inputs.hardware.nixosModules.raspberry-pi-4

    (lib.custom.relativeToRoot "modules/default.nix")
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "hermes";
    users = [ config.hostSpec.primaryUsername ];
    mapNFSshares = true;
    podman = true;
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault false;
      efi.canTouchEfiVariables = lib.mkDefault false;
      timeout = 3;
    };
    #initrd.systemd.enable = true;
  };

  system.stateVersion = "24.05";
}
