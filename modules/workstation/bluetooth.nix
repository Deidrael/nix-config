# Enable bluetooth
{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.isWorkstation {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
