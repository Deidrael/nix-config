{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.desktopApps.tools {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      remmina
      vscodium
      ;
  };
}
