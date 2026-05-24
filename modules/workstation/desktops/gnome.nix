{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.desktop.gnome.enable {
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.gtile
    ];
  };
}
