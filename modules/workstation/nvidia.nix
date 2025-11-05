{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hostSpec.hasNvidia {
    #Prime
    hardware = {
      nvidia = {
        modesetting.enable = lib.mkDefault true;
        open = lib.mkDefault true;
        powerManagement = {
          enable = lib.mkDefault true;
          finegrained = lib.mkDefault true;
        };
      };
      nvidia-container-toolkit.enable = lib.mkDefault true;
    };

    specialisation.gpusync.configuration = {
      system.nixos.tags = [ "gpusync" ];
      hardware.nvidia = {
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        prime = {
          offload.enable = false;
          offload.enableOffloadCmd = false;
          sync.enable = true;
        };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
