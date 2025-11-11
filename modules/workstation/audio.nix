# Audio configuration for workstation hosts using PipeWire instead of PulseAudio
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
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = [
      pkgs.pwvucontrol
    ];
  };
}
