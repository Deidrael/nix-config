{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.desktopGnome {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.gtile
    ];
  };
}
