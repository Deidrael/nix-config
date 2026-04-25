{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #################### Required Configs ####################
    (inputs.import-tree ./common/core)

    #################### Host-specific Optional Configs ####################
    (inputs.import-tree (lib.custom.relativeToRoot "home/common/hyprui"))
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ;
  };

  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun -H 600 -W 800";
    "$browser" = "firefox";
  };
}
