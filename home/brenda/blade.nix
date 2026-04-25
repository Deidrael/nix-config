{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    #################### Required Configs ####################
    (inputs.import-tree ./common/core)

    #################### Host-specific Optional Configs ####################
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ;
  };
}
