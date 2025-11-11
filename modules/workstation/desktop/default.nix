{
  config,
  lib,
  ...
}:
let
  defaultSession =
    {
      "sddm" = "hyprland";
      "lightdm" = "cinnamon";
      "gdm" = "gnome";
    }
    .${config.hostSpec.desktop.displayManager} or "";
in
{

  imports = lib.custom.scanPaths ./.;

  config = lib.mkIf config.hostSpec.isWorkstation {
    hardware.graphics.enable = true;

    services = {
      xserver.enable = true;

      # SDDM configuration
      displayManager.sddm = lib.mkIf (config.hostSpec.desktop.displayManager == "sddm") {
        enable = true;
        wayland.enable = true;
      };

      # GDM configuration
      displayManager.gdm = lib.mkIf (config.hostSpec.desktop.displayManager == "gdm") {
        enable = true;
      };

      # LightDM configuration
      xserver.displayManager.lightdm = lib.mkIf (config.hostSpec.desktop.displayManager == "lightdm") {
        enable = true;
      };

      # Default session
      displayManager.defaultSession = defaultSession;
    };
  };
}
