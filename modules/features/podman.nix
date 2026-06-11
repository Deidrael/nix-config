{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.podman {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      docker-compose
    ];
  };
}
