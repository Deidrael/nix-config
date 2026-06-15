{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.role.gaming {
  home.packages = [
    pkgs.space-cadet-pinball
  ];
}
