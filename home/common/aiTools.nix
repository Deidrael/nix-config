{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.aiTools {
  home.packages = [
    pkgs.opencode
  ]
  ++ lib.optionals (hostSpec.role.type == "workstation") [
    pkgs.zed-editor
  ];
}
