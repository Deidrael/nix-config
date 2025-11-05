{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.isGaming {
    #Prime
    hardware = {
      nvidia = {
        modesetting.enable = true;
        open = true;
        powerManagement = {
          enable = true;
          finegrained = true;
        };
        primeBatterySaverSpecialisation = lib.mkIf config.hostSpec.hasNvidia true;
      };
      nvidia-container-toolkit.enable = true;
    };

    specialisation.gpusync.configuration = {
      system.nixos.tags = [ "gpusync" ];
      hardware.nvidia = {
        powerManagement = {
          enable = lib.mkForce false;
          finegrained = lib.mkForce false;
        };
        prime = {
          offload.enable = lib.mkForce false;
          offload.enableOffloadCmd = lib.mkForce false;
          sync.enable = lib.mkForce true;
        };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
