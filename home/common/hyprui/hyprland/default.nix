{
  hostSpec,
  lib,
  ...
}:
{
  imports = lib.custom.scanPaths ./.;

  config = lib.mkIf (hostSpec.desktop.hyprland.enable) {
    # assertions = [
    #   {
    #     assertion = config.hostSpec.desktop.hyprland.enable;
    #     message = "make sure to enable hyprland on the host for required dependencies like xdg-desktop portal etc.";
    #   }
    # ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        ### AUTOSTART ###
        exec-once = [
          "hyprpaper"
          "hypridle"
          "waybar"
          "$browser"
          "dunst"
          "systemctl --user start hyprpolkitagent"
        ];

        # fallback rule matching any monitor
        monitor = [ ", preferred, auto, 1" ];

        windowrule = [
          "suppress_event maximize, match:class .*"
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
        ];
      };
    };
  };
}
