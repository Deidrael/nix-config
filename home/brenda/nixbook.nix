{ lib, pkgs, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
    (lib.custom.relativeToRoot "home/common/hyprui")
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      ;
  };
}
