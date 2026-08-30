{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.desktopApps.remote {
  home.packages = builtins.attrValues {
    inherit (pkgs) remmina;
  };
}
