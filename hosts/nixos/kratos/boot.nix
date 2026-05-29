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
    kernelModules = [
      "kvm-intel"
      "vfio-pci"
    ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [ "intel_iommu=on" ];
    kernelPackages = pkgs.linuxPackages_xanmod;
    extraModulePackages = [ ];
  };
}
