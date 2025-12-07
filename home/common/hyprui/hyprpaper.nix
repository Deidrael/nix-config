# Hyprpaper Configuration
{
  hostSpec,
  lib,
  ...
}:
lib.mkIf (hostSpec.desktop.hyprland.enable) {
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = true; # Enable splash screen
      ipc = true; # Enable IPC socket
      preload = [
        # Preload wallpapers
      ];
      wallpaper = [
      ];
    };
  };
}
