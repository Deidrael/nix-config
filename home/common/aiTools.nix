{
  hostSpec,
  lib,
  pkgs,
  ...
}:
lib.mkIf hostSpec.aiTools {
  home.packages =
    with pkgs;
    [
      opencode
    ]
    ++ lib.optionals (hostSpec.role.type == "workstation") [
      zed-editor
    ];
}
