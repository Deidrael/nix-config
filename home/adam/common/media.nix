{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.desktopApps.media {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      audacity
      musescore
      ;
  };
}
