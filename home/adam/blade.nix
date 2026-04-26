{
  inputs,
  lib,
  ...
}:
{
  imports = [
    # ========== Required Configs ==========
    (inputs.import-tree ./common/core)
    (inputs.import-tree (lib.custom.relativeToRoot "home/common"))

    # ========== Host-specific Optional Configs ==========
    common/optional/browsers
    common/optional/media
    common/optional/social
    common/optional/tools
  ];
}
