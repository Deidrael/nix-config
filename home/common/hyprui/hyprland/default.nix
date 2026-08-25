{
  hostSpec,
  lib,
  ...
}:
let
  lua = lib.generators.mkLuaInline;
  on = event: body: {
    _args = [
      event
      (lua "function() ${body} end")
    ];
  };
  exec = cmd: ''hl.exec_cmd("${cmd}")'';
in
{
  config = lib.mkIf hostSpec.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      settings = {
        ### AUTOSTART ###
        on = [
          (on "hyprland.start" ''
            ${exec "hyprpaper"}
            ${exec "waybar"}
            ${exec "firefox"}
            ${exec "dunst"}
            ${exec "systemctl --user start hyprpolkitagent"}
          '')
        ];

        # fallback rule matching any monitor
        monitor = [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "1";
          }
        ];

        window_rule = [
          {
            match = {
              class = ".*";
            };
            suppress_event = "maximize";
          }
          {
            match = {
              class = "^$";
              title = "^$";
              xwayland = true;
              float = true;
              fullscreen = false;
              pin = false;
            };
            no_focus = true;
          }
        ];
      };
    };
  };
}
