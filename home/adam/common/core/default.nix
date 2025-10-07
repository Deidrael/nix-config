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
      "modules/common/hostSpec.nix"
      #"modules/home"
    ])
    (lib.custom.scanPaths ./.)
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.primaryUsername;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "24.05";
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
    };

  };

  #home.packages =
  #  #    [ ] ++ builtins.attrValues {
  #  builtins.attrValues {
  #    inherit (pkgs)
  #      ;
  #  };

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
