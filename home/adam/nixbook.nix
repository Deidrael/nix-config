{ lib, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers/firefox.nix
    common/optional/tools/default.nix
    (lib.custom.relativeToRoot "home/common/hyprui")
  ];

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun -H 600 -W 800";
    "$browser" = "firefox";
  };
}
