{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.threeDTools {
  home.packages = [
    pkgs.blender
    pkgs.freecad
    pkgs.inkscape
    pkgs.prusa-slicer
  ];
}
