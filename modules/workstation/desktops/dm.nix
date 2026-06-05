{
  config,
  lib,
  ...
}:
let
  isWorkstation = config.hostSpec.role.type == "workstation";

  # Maps DM name → desktop session (sddm→hyprland, lightdm→cinnamon, gdm→gnome)
  defaultSession =
    {
      "sddm" = "hyprland";
      "lightdm" = "cinnamon";
      "gdm" = "gnome";
    }
    .${config.hostSpec.desktop.displayManager} or "";
in
{
  config = lib.mkIf isWorkstation {
    hardware.graphics.enable = true;

    services = {
      xserver.enable = true;

      displayManager = {
        inherit defaultSession;

        sddm = lib.mkIf (config.hostSpec.desktop.displayManager == "sddm") {
          enable = true;
          wayland.enable = true;
        };

        gdm = lib.mkIf (config.hostSpec.desktop.displayManager == "gdm") {
          enable = true;
        };
      };

      # LightDM lives under xserver.displayManager (X11-only, not Wayland-capable)
      xserver.displayManager.lightdm = lib.mkIf (config.hostSpec.desktop.displayManager == "lightdm") {
        enable = true;
      };
    };
  };
}
