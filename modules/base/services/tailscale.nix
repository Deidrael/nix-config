{
  config,
  lib,
  pkgs,
  ...
}:
let
  serve = config.hostSpec.tailscale.serve;
in
{
  services.tailscale = {
    enable = lib.mkDefault config.hostSpec.tailscale.enable;
    useRoutingFeatures = lib.mkDefault config.hostSpec.tailscale.routingFeatures;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  systemd.services.tailscale-serve = lib.mkIf serve.enable {
    description = "Tailscale serve proxy";
    wantedBy = [ "multi-user.target" ];
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];

    # --bg persists serve.json in tailscaled state, so the config survives
    # reboots and the oneshot is idempotent
    script = ''
      # Wait up to 30s for tailscaled to be up and authenticated
      _tries=0
      until tailscale status >/dev/null 2>&1 || [ "$_tries" -ge 30 ]; do
        _tries=$((_tries + 1))
        sleep 1
      done
      exec tailscale serve --bg --yes --https=${toString serve.httpsPort} --set-path=${serve.path} ${serve.backend}
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 10;
    };

    path = [
      config.services.tailscale.package
      pkgs.bash
      pkgs.coreutils
    ];
  };
}
