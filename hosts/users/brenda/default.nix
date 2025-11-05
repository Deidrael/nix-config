# User config
{
  config,
  lib,
  hostSpec,
  ...
}:
{
  isNormalUser = true;
  description = hostSpec.secondaryUserFullName;
  extraGroups =
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    lib.flatten [
      (ifTheyExist [
        "audio"
        "video"
        "networkmanager"
        "scanner" # for print/scan"
        "lp" # for print/scan"
      ])
    ];
}
