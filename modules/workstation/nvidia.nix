{
  config,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    # Non-NVIDIA: use modesetting driver
    (lib.mkIf (!config.hostSpec.hasNvidiaPrime) {
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    })

    # NVIDIA: configure nvidia
    (lib.mkIf config.hostSpec.hasNvidiaPrime {
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

      services.xserver.videoDrivers = [ "nvidia" ];
    })
  ];
}
