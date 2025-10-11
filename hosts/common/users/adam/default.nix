{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  # Decrypt password to /run/secrets-for-users/ so it can be used to create the user
  sopsHashedPasswordFile = config.sops.secrets."passwords/${hostSpec.primaryUsername}".path;
in
{
  users.mutableUsers = false; # Only allow declarative credentials; Required for password to be set via sops during system activation!
  users.users = {
    ${hostSpec.primaryUsername} = {
      name = hostSpec.primaryUsername;
      home = "/home/${hostSpec.primaryUsername}";
      description = hostSpec.userFullName;
      isNormalUser = true;
      hashedPasswordFile = sopsHashedPasswordFile; # Blank if sops is not working.

      extraGroups = lib.flatten [
        "wheel"
        (ifTheyExist [
          "audio"
          "video"
          "input"
          "docker"
          "git"
          "networkmanager"
          "scanner" # for print/scan"
          "lp" # for print/scan"
        ])
      ];

      # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
      openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);
    };

    # root's ssh key are mainly used for remote deployment, borg, and some other specific ops
    root = {
      hashedPasswordFile = config.users.users.${hostSpec.primaryUsername}.hashedPasswordFile;
      hashedPassword = config.users.users.${hostSpec.primaryUsername}.hashedPassword; # This comes from hosts/common/optional/minimal.nix and gets overridden if sops is working
      openssh.authorizedKeys.keys =
        config.users.users.${hostSpec.primaryUsername}.openssh.authorizedKeys.keys; # root's ssh keys are mainly used for remote deployment.
    };
  };

  # No matter what environment we are in we want these tools for root, and the user(s)
  programs.git.enable = true;

  # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
  systemd.tmpfiles.rules =
    let
      user = config.users.users.${hostSpec.primaryUsername}.name;
      group = config.users.users.${hostSpec.primaryUsername}.group;
    in
    # you must set the rule for .ssh separately first, otherwise it will be automatically created as root:root and .ssh/sockects will fail
    [
      "d /home/${hostSpec.primaryUsername}/.ssh 0750 ${user} ${group} -"
      "d /home/${hostSpec.primaryUsername}/.ssh/sockets 0750 ${user} ${group} -"
    ];

  # No matter what environment we are in we want these tools
  environment.systemPackages = with pkgs; [
    just
    rsync

    # Packages that don't have custom configs go here
    age
    btop # resource monitor
    cachix
    coreutils # basic gnu utils
    curl
    delta
    git
    gh
    htop
    p7zip # compression & encryption
    pre-commit # git hooks
    sops
    ssh-to-age
    tmux
    #toybox
    unzip # zip extraction
    vim-full
    wget # downloader

    jq
    #steam-run # for running non-NixOS-packaged binaries on Nix
    yq-go # yaml pretty printer and manipulator
    zip # zip compression
  ];
}
# Import the user's personal/home configurations, unless the environment is minimal
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.primaryUsername}.imports = lib.flatten (
      { config, ... }:
      import (lib.custom.relativeToRoot "home/${hostSpec.primaryUsername}/${hostSpec.hostName}.nix") {
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
