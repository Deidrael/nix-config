# Hyprlock Configuration (declarative)
{
  hostSpec,
  lib,
  ...
}:
lib.mkIf (hostSpec.desktop.hyprland.enable) {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          dots_spacing = 0.2;
          fade_on_empty = false;
          placeholder_text = "Password";
        }
      ];

      label = [
        {
          text = "cmd[60] whoami";
          font_size = 22;
          color = "rgba(230,230,230,1.0)";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }

        {
          text = "$TIME";
          font_size = 34;
          color = "rgba(230,230,230,1.0)";
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
