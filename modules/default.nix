{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    (lib.custom.scanPaths ./.)
    (map lib.custom.relativeToRoot [
      "hosts/users"
    ])
  ];

  # ========== Core Host Specifications ==========
  hostSpec = {
    inherit (inputs.nix-secrets)
      primaryUsername
      primaryUserFullName
      handle
      domain
      email
      secondaryUsername
      secondaryUserFullName
      nfsServer
      nfsShareNames
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

}
