{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [ inputs.hardware.nixosModules.common-gpu-nvidia ];

  config = lib.mkMerge [
    # Non-NVIDIA: override defaults set by common-gpu-nvidia
    (lib.mkIf (!config.hostSpec.hasNvidia) {
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
    })

    # NVIDIA: configure nvidia
    (lib.mkIf config.hostSpec.hasNvidia {
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

      hardware.nvidia.primeBatterySaverSpecialisation = lib.mkDefault true;

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
    })
  ];
}
