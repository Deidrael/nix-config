{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # ========== Disk Layout ==========
    #inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")

    # ========== Misc Inputs ==========

    (map lib.custom.relativeToRoot [
      # ========== Required Configs ==========
      "hosts/common"

      # ========== Optional Configs ==========
      "hosts/common/optional/services/daedalus-nfs.nix"
      "hosts/common/optional/services/docker.nix"
      "hosts/common/optional/services/openssh.nix"
    ])
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "kronos";
  };

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
      timeout = 3;
    };
    initrd = {
      systemd.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
