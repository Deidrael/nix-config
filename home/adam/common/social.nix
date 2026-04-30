{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.desktopApps.social {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      discord
      element-desktop
      mumble
      ;
  };
}
