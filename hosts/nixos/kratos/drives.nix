{
  lib,
  ...
}:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2c493fd5-f135-44af-84d1-9de9af12e9aa";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/2c493fd5-f135-44af-84d1-9de9af12e9aa";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/2c493fd5-f135-44af-84d1-9de9af12e9aa";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/ED82-CAED";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/2c493fd5-f135-44af-84d1-9de9af12e9aa";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp44s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp45s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
