# Enable bluetooth
{
  config,
  lib,
  ...
}:
let
  isWorkstation = config.hostSpec.role.type == "workstation";
in
{
  config = lib.mkIf isWorkstation {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
