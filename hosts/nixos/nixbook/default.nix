{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    ./keyboard.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # ========== Disk Layout ==========
    #inputs.disko.nixosModules.disko
    #(lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")

    # ========== Misc Inputs ==========

    (map lib.custom.relativeToRoot [
      # ========== Required Configs ==========
      "hosts/common"

      # ========== Non-Primary Users to Create ==========
      "hosts/common/users/brenda"

      # ========== Optional Configs ==========
      "hosts/common/optional/desktops/cinnamon.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/printing.nix"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/scanner.nix"
    ])
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "nixbook";
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
