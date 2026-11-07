{
  config,
  lib,
  pkgs,
  ...
}:
let
  isWorkstation = config.hostSpec.role.type == "workstation";
in
{
  config = lib.mkIf isWorkstation {
    # SANE - scanner access now easy
    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.hplipWithPlugin
        pkgs.sane-airscan
      ];
    };
    services.udev.packages = [ pkgs.sane-airscan ];
    services.ipp-usb.enable = true;

    # sane-backends (scanimage, sane-find-scanner) is added by hardware.sane.enable
    environment.systemPackages = [
      pkgs.simple-scan # GUI scanning application
    ];

    # If your scanner is networked, you might need to open a port
    # networking.firewall.allowedTCPPorts = [ 9100 ];
  };
}
