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
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # ========== Disk Layout ==========
    #inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")

    # ========== Misc Inputs ==========

    (map lib.custom.relativeToRoot [
      # ========== Required Configs ==========
      "hosts/common/core"

      # ========== Optional Configs ==========
      "hosts/common/optional/services/daedalus-nfs.nix"
      "hosts/common/optional/services/docker.nix"
      "hosts/common/optional/services/openssh.nix"
    ])
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "hermes";
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
      systemd-boot = {
        enable = lib.mkDefault false;
      };
      efi.canTouchEfiVariables = lib.mkDefault false;
      timeout = 3;
    };
    initrd = {
      systemd.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
