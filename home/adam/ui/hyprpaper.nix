# Hyprpaper Configuration
{ ... }:
{
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
