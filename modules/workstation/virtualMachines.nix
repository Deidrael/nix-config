{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hostSpec.virtualMachines {
    virtualisation = {
      waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };
      libvirtd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      dnsmasq
      qemu
      waydroid-helper
    ];

    programs = {
      virt-manager.enable = true;
    };
  };
}
