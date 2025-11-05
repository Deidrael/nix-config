{ config, lib, ... }:
let
  defaultSession =
    {
      "sddm" = "hyprland";
      "lightdm" = "cinnamon";
      "gdm" = "gnome";
    }
    .${config.hostSpec.displayManager} or "";
in
{
  imports = lib.custom.scanPaths ./.;

  config = lib.mkIf config.hostSpec.isWorkstation {
    hardware.graphics.enable = true;

    services = {
      xserver.enable = true;

      # SDDM configuration
      displayManager.sddm = lib.mkIf (config.hostSpec.displayManager == "sddm") {
        enable = true;
        wayland.enable = true;
      };

      # GDM configuration
      displayManager.gdm = lib.mkIf (config.hostSpec.displayManager == "gdm") {
        enable = true;
      };
      desktopManager.gnome = lib.mkIf (config.hostSpec.displayManager == "gdm") {
        enable = true;
      };

      # LightDM configuration
      xserver.displayManager.lightdm = lib.mkIf (config.hostSpec.displayManager == "lightdm") {
        enable = true;
      };
      xserver.desktopManager.cinnamon = lib.mkIf (config.hostSpec.displayManager == "lightdm") {
        enable = true;
      };

      # Default session
      displayManager.defaultSession = defaultSession;
    };
  };
}
