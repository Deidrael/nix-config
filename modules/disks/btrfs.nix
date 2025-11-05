# Standard btrfs settings
{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.fsBtrfs {
    fileSystems = {
      "/".options = [ "compress=zstd" ];
      "/home".options = [ "compress=zstd" ];
      "/nix".options = [
        "compress=zstd"
        "noatime"
      ];
      "/swap".options = [ "noatime" ];
    };

    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };
}
