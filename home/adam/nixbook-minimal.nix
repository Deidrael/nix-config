{
  inputs,
  lib,
  ...
}:
{
  imports = [
    (inputs.import-tree ./common)
    (inputs.import-tree (lib.custom.relativeToRoot "home/common"))
  ];
}
