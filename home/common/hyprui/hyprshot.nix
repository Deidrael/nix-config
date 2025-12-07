# hypridle configuration
{
  hostSpec,
  lib,
  ...
}:
lib.mkIf (hostSpec.desktop.hyprland.enable) {
  programs.hyprshot = {
    enable = true;
    saveLocation = "$HOME/Pictures/Screenshots";
  };
}
