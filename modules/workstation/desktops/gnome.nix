{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.desktop.gnome.enable {
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = [
      pkgs.gnomeExtensions.gtile
    ];
  };
}
