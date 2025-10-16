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
      "modules/workstation"
      "modules/desktop/gnome.nix"
      "modules/gaming"
    ])
  ];

  # ========== Computer Specific Packages ==========
  environment.systemPackages = with pkgs; [
    discord
    stable.openrct2
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
