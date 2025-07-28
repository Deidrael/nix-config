{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
    (lib.custom.scanPaths ./.)
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "24.05";
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
    };

  };

  home.packages =
    #    [ ] ++ builtins.attrValues {
    builtins.attrValues {
      inherit (pkgs)
        # Packages that don't have custom configs go here
        age
        btop # resource monitor
        cachix
        coreutils # basic gnu utils
        curl
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
        steam-run # for running non-NixOS-packaged binaries on Nix
        yq-go # yaml pretty printer and manipulator
        zip # zip compression
        ;
    };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
