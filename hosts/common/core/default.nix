{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    (lib.custom.scanPaths ./.)

    (map lib.custom.relativeToRoot [
      "modules/common"
      "hosts/common/users/adam"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    primaryUsername = "adam";
    handle = "Deidrael";
    inherit (inputs.nix-secrets)
      domain
      email
      userFullName
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = with pkgs; [
    openssh
  ];

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

}
