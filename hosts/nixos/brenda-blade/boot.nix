{
  ...
}:
{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
}
