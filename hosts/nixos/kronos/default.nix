{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    # ========== Hardware ==========
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "kronos";
    fsBtrfs = true;
    role = {
      type = "server";
    };
    aiTools = {
      enable = true;
      model = "qwen3.5:4b";
    };
    tailscale.routingFeatures = "both";
    nfsClient.enable = true;
    podman = true;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
      timeout = 3;
    };
    initrd = {
      systemd.enable = true;
    };
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

}
