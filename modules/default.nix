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
    (map lib.custom.relativeToRoot [
      "hosts/users"
    ])
  ];

  # ========== Core Host Specifications ==========
  hostSpec = {
    inherit (inputs.nix-secrets) users domain nfsClient;
  };

  networking.hostName = config.hostSpec.hostName;
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

}
