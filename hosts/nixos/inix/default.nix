{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.apple-imac-14-2

    # ========== Disk Layout ==========
    #inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")

    # ========== Misc Inputs ==========

    (map lib.custom.relativeToRoot [
      # ========== Required Configs ==========
      "hosts/common/core"

      # ========== Optional Configs ==========
      "hosts/common/optional/desktops/cinnamon.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/printing.nix"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/scanner.nix"
    ])
  ];

  hardware = {
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "inix";
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
    };
    initrd = {
      systemd.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
