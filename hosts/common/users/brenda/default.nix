{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  hostSpec = config.hostSpec;
  secretsSubPath = "passwords/brenda";
in
{
  # Decrypt passwords/brenda to /run/secrets-for-users/ so it can be used to create the user
  sops.secrets.${secretsSubPath}.neededForUsers = true;
  users.mutableUsers = false; # Required for password to be set via sops during system activation!

  users.users.brenda = {
    isNormalUser = true;
    description = " Brenda Wilson";
    hashedPasswordFile = config.sops.secrets.${secretsSubPath}.path;
    extraGroups = lib.flatten [
      (ifTheyExist [
        "audio"
        "video"
        "networkmanager"
        "scanner" # for print/scan"
        "lp" # for print/scan"
      ])
    ];
  };
}
# Import this user's personal/home configurations
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.brenda.imports = lib.flatten (
      { config, ... }:
      import (lib.custom.relativeToRoot "home/brenda/${hostSpec.hostName}.nix") {
        inherit
          pkgs
          inputs
          config
          lib
          hostSpec
          ;
      }
    );
  };
}
