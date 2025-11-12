# User config
{
  config,
  lib,
  ...
}:
{
  isNormalUser = true;
  description = config.hostSpec.users.primary.fullName;
  extraGroups =
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    lib.flatten [
      "wheel"
      (ifTheyExist [
        "audio"
        "video"
        "input"
        "docker"
        "podman"
        "git"
        "networkmanager"
        "scanner" # for print/scan"
        "lp" # for print/scan"
      ])
    ];
}
