{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./boot.nix
    ./drives.nix
    ./nvidia.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    # ========== Disk Layout ==========
    #inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")

    # ========== Misc Inputs ==========

    (map lib.custom.relativeToRoot [
      # ========== Required Configs ==========
      "hosts/common"

      # ========== Non-Primary Users to Create ==========
      "hosts/common/users/brenda"

      # ========== Optional Configs ==========
      "hosts/common/optional/desktops/gnome.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/printing.nix"
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/gaming.nix"
      "hosts/common/optional/nvidia.nix"
      "hosts/common/optional/scanner.nix"
    ])
  ];

  environment.systemPackages = with pkgs; [
    discord
    openrct2
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "blade";
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
