{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers
    common/optional/media
    common/optional/social
    common/optional/tools
    ui/default.nix
  ];

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun -H 600 -W 800";
    "$browser" = "firefox";

    monitor = [
      "eDP-1,preferred,0x0,1"
      "desc:Acer Technologies XZ342CK TKNAA0013900,highrr,-3440x0,1"
      "HDMI-A-5,1920x1080,auto-left,1"
    ];

    workspace = [
      "1, monitor:eDP-1"
      "2, monitor:DP-5"
    ];
  };
}
