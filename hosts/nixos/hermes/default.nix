{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "hermes";
    role = {
      type = "server";
    };
    tailscale = {
      routingFeatures = "both";
      serve = {
        enable = true;
      };
    };
    nfsClient.enable = true;
    podman = true;
    hermes = {
      enable = true;
      stateDir = "/share/Docker/Hermes";
      package = "messaging";
      waitForNfs = {
        enable = true;
      };
      dashboard = {
        enable = true;
        host = "0.0.0.0";
        port = 9119;
      };
      searxng = {
        url = "https://search.macaroni-ghoul.ts.net";
      };
      discord = {
        enable = true;
        botTokenSecret = "hermes/discord-token";
        allowedUsers = "180950849130987520";
        homeChannel = "1541984518322397327";
      };
    };
  };

  # Compressed in-memory swap; disk swap devices are disabled below
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # Daemon is enabled by default; slices are not
  systemd.oomd = {
    enableRootSlice = true;
    enableSystemSlice = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault false;
      efi.canTouchEfiVariables = lib.mkDefault false;
      timeout = 3;
    };
    # Pi kernel has CONFIG_PSI_DEFAULT_DISABLED=y; oomd slices need psi enabled
    kernelParams = [ "psi=1" ];
    #initrd.systemd.enable = true;
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  swapDevices = [ ];

}
