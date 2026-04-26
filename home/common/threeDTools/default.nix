{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.threeDTools {
  home.packages = with pkgs; [
    blender
    freecad
    inkscape
    prusa-slicer
  ];
}
