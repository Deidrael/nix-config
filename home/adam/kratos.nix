{
  inputs,
  lib,
  ...
}:
{
  imports = [
    (inputs.import-tree ./common)
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "preferred";
        position = "0x0";
        scale = "1";
      }
      {
        output = "desc:Acer Technologies XZ342CK TKNAA0013900";
        mode = "highrr";
        position = "-3440x0";
        scale = "1";
      }
      {
        output = "HDMI-A-5";
        mode = "1920x1080";
        position = "auto-left";
        scale = "1";
      }
    ];

    workspace_rule = [
      {
        workspace = "1";
        monitor = "eDP-1";
        default = true;
      }
      {
        workspace = "2";
        monitor = "DP-5";
        default = true;
      }
    ];

    config.input = {
      kb_options = "caps:none";
    };

    bind = [
      {
        _args = [
          "Caps_Lock"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"mumble rpc togglemute\")")
        ];
      }
    ];
  };
}
