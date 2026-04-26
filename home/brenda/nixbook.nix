{
  inputs,
  lib,
  ...
}:
{
  imports = [
    #################### Required Configs ####################
    (inputs.import-tree ./common/core)
    (inputs.import-tree (lib.custom.relativeToRoot "home/common"))

    #################### Host-specific Optional Configs ####################
  ];

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun -H 600 -W 800";
    "$browser" = "firefox";
  };
}
