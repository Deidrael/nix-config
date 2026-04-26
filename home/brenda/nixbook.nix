{
  inputs,
  lib,
  ...
}:
{
  imports = [
    #################### Required Configs ####################
    (inputs.import-tree ./common/core)
    (inputs.import-tree (lib.custom.relativeToRoot "home/common"))
  ];
}
