{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.desktop.cinnamon.enable {
    services.xserver.desktopManager.cinnamon.enable = true;

    environment.systemPackages = [
      # Add any Cinnamon-specific packages here if needed
    ];
  };
}
