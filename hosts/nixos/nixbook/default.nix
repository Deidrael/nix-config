{
  inputs,
  lib,
  pkgs,
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
    hostName = "nixbook";
    users.secondary.enable = true;
    role = {
      type = "workstation";
    };
    desktop = {
      displayManager = "sddm";
      hyprland.enable = true;
    };
    desktopApps = {
      firefox = true;
      tools = true;
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    initrd = {
      systemd.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=3
      options snd-sof sof_debug=1
    '';
  };

  # Chromebook keyboard quirks
  services.xserver.xkb.model = "chromebook";

  swapDevices = [ { device = "/dev/disk/by-uuid/26c93dda-2270-4044-b2fc-c94e48832c9a"; } ];

  system.stateVersion = "24.05";
}
