{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };
  nix = {
    optimise.automatic = true; # defaults to 03:45
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB
      experimental-features = lib.mkDefault "nix-command flakes";
      warn-dirty = false;
      allow-import-from-derivation = true;
      trusted-users = [ "@wheel" ];

      # Binary Cache
      substituters = [
        "https://deidrael.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "deidrael.cachix.org-1:73m+qt2qGNI8fhTuM0qwDM3QQM6WdGLxELwucd3+JdA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Disabled because we use nh
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 5d";
    #   persistent = true;
    # };
  }
  // (lib.optionalAttrs pkgs.stdenv.isLinux {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

  });
}
