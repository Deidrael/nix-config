{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf (hostSpec.role.type == "workstation") {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      discord
      element-desktop
      mumble
      ;
  };
}
