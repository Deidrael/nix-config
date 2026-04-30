{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf (hostSpec.role.gaming) {
  home.packages = with pkgs; [
    stable.openrct2
  ];
}
