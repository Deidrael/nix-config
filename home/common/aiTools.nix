{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.aiTools.enable {
  home.packages = [
    pkgs.opencode
  ]
  ++ lib.optionals (hostSpec.role.type == "workstation") [
    pkgs.zed-editor
  ];
}
