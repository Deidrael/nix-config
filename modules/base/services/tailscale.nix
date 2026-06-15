{
  config,
  lib,
  ...
}:
{
  services.tailscale = {
    enable = lib.mkDefault config.hostSpec.tailscale.enable;
    useRoutingFeatures = lib.mkDefault config.hostSpec.tailscale.routingFeatures;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
