{
  pkgs,
  ...
}:
{
  boot = {
    initrd.availableKernelModules = [
      "vmd"
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_xanmod;
    extraModulePackages = [ ];
  };
}
