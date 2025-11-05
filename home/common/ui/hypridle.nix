# hypridle configuration
_: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 270;
          on-timeout = "brightnessctl -s set 1";
          on-resume = "brightnessctl -r";
        }

        {
          # 5 minutes: lock desktop
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          # 5.5 minutes: blank displays via DPMS off
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
