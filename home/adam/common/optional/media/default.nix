{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf (hostSpec.role.type == "workstation") {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      audacity
      musescore
      ;
    inherit (pkgs.stable)
      #audacity
      ;
  };
}
