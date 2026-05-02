{
  inputs,
  lib,
  ...
}:
{
  imports = [
    # ========== Required Configs ==========
    (inputs.import-tree ./common)
    (inputs.import-tree (lib.custom.relativeToRoot "home/common"))
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,preferred,0x0,1"
      "desc:Acer Technologies XZ342CK TKNAA0013900,highrr,-3440x0,1"
      "HDMI-A-5,1920x1080,auto-left,1"
    ];

    workspace = [
      "1, monitor:eDP-1"
      "2, monitor:DP-5"
    ];

    input = {
      kb_options = "caps:none";
    };
    bind = [
      ", Caps_Lock, exec, mumble rpc togglemute"
    ];
  };
}
