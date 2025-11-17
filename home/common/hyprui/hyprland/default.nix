{
  # config,
  lib,
  ...
}:
{
  imports = lib.custom.scanPaths ./.;

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
      ];

      # fallback rule matching any monitor
      monitor = [ ", preferred, auto, 1" ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };

}
