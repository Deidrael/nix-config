{
  hostSpec,
  lib,
  ...
}:
lib.mkIf hostSpec.desktopApps.coding.enable {
  home.packages = [ hostSpec.desktopApps.coding.package ];
}
